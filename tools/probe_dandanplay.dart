import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mamba_tv/data/services/dandanplay_service.dart';

Future<void> main(List<String> arguments) async {
  final clockSkewTest = arguments.contains('--clock-skew-test');
  final configArguments = arguments
      .where((arg) => arg != '--clock-skew-test')
      .toList();
  final home =
      Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
  final file = configArguments.isEmpty
      ? '$home/.config/mamba-tv/dandanplay.json'
      : configArguments.single;
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  var timestampRejections = 0;
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.statusCode == 403 &&
            response.headers.value('x-error-message') == 'Invalid Timestamp') {
          timestampRejections++;
        }
        handler.next(response);
      },
    ),
  );
  try {
    final values =
        jsonDecode(await File(file).readAsString()) as Map<String, dynamic>;
    final service = DandanplayService(
      dio,
      DandanplayCredentials(
        values['DANDANPLAY_APP_ID'] as String,
        values['DANDANPLAY_APP_SECRET'] as String,
      ),
      now: clockSkewTest
          ? () => DateTime.now().subtract(const Duration(hours: 22))
          : null,
    );
    final metadata = await service.bangumi(400602);
    final bangumi = metadata['bangumi'] as Map;
    final episodes = bangumi['episodes'] as List;
    final first = episodes.cast<Map>().singleWhere(
      (row) => row['episodeNumber'] == '1',
    );
    final comments = await service.comments(
      (first['episodeId'] as num).toInt(),
    );
    if (comments.isEmpty) throw StateError('Live probe expected comments');
    if (clockSkewTest && timestampRejections != 1) {
      throw StateError(
        'Clock skew probe expected exactly one timestamp rejection',
      );
    }
    stdout.writeln(
      jsonEncode({
        'mode': 'live-dandanplay-signed-api',
        'clockSkewTest': clockSkewTest,
        'timestampRejections': timestampRejections,
        'subjectId': 400602,
        'episodeId': first['episodeId'],
        'episodes': episodes.length,
        'comments': comments.length,
        'firstTimeMs': comments.first.timeMs,
        'lastTimeMs': comments.last.timeMs,
      }),
    );
  } catch (error) {
    stderr.writeln('弹弹play真实接口探针失败 (${error.runtimeType})；请检查本机凭证文件和网络。');
    exitCode = 1;
  } finally {
    dio.close(force: true);
  }
}
