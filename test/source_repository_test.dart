import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:mamba_tv/app/logging.dart';
import 'package:mamba_tv/data/repositories/source_repository.dart';
import 'package:mamba_tv/data/services/maccms_service.dart';
import 'package:mamba_tv/domain/failure.dart';

import 'support/maccms_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('MacCMS requests preserve endpoint parameters, pagination, lines and exact URLs', () async {
    final dio = Dio();
    addTearDown(dio.close);
    final requests = <RequestOptions>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          final data = options.queryParameters['ac'] == 'detail'
              ? macCmsDetail()
              : macCmsList(page: options.queryParameters['pg'] as int);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: jsonEncode(data),
            ),
          );
        },
      ),
    );
    final service = MacCmsService(dio);
    final first = await service.search(configuredSource, '测试');
    final second = await service.search(configuredSource, '测试', page: 2);
    expect(requests.first.queryParameters, {
      'key': 'private',
      'ac': 'list',
      'wd': '测试',
      'pg': 1,
      'at': 'json',
    });
    expect(first.items.single.id, '7');
    expect(second.items.single.id, '8');
    expect(second.page, 2);
    final lines = await service.lines(configuredSource, '7');
    expect(requests.last.queryParameters['ids'], '7');
    expect(lines.map((line) => line.name), ['hls', 'web']);
    expect(lines.first.episodes.map((episode) => episode.label), [
      '第1集',
      '第2集',
    ]);
    expect(
      lines.first.episodes.first.address,
      'https://example.com/1.m3u8?token=test-secret',
    );
    expect(
      lines.first.episodes.every((episode) => episode.directlyPlayable),
      true,
    );
    expect(lines.last.episodes.single.directlyPlayable, false);
  });

  test(
    'filtered comma-separated play groups and invalid API responses',
    () async {
      final dio = Dio();
      addTearDown(dio.close);
      Object response = macCmsDetail(from: 'hls,web');
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: response),
          ),
        ),
      );
      final service = MacCmsService(dio);
      expect(
        (await service.lines(configuredSource, '7')).map((line) => line.name),
        ['hls', 'web'],
      );
      await expectLater(
        service.lines(configuredSource, '9'),
        throwsFormatException,
      );
      response = {'code': 0, 'msg': 'closed'};
      await expectLater(service.check(configuredSource), throwsFormatException);
      response = '<html>not a JSON API</html>';
      await expectLater(service.check(configuredSource), throwsFormatException);
    },
  );

  test('source configuration survives repository recreation and serializes concurrent edits', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final preferences = SharedPreferencesAsync();
    final dio = Dio();
    addTearDown(dio.close);
    final service = MacCmsService(dio);
    final talker = createAppTalker(console: false);
    final repository = PreferencesSourceRepository(
      preferences,
      service,
      talker,
    );
    final second = configuredSource.copyWith(id: 'second', enabled: false);
    await Future.wait([
      repository.save(configuredSource),
      repository.save(second),
    ]);
    final reopened = PreferencesSourceRepository(
      SharedPreferencesAsync(),
      service,
      talker,
    );
    expect(await reopened.load(), [configuredSource, second]);
    await repository.remove('test');
    expect(await reopened.load(), [second]);
    for (final endpoint in [
      'http://example.com/api',
      'https://user:pass@example.com/api',
      'https://example.com/api#fragment',
    ]) {
      expect(
        () => repository.save(configuredSource.copyWith(endpoint: endpoint)),
        throwsA(isA<AppFailure>()),
      );
    }
  });
}
