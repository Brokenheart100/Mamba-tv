import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mamba_tv/data/services/animeko_source_service.dart';
import 'package:mamba_tv/domain/video_source.dart';

Future<void> main() async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  var stage = 'subscription';
  try {
    final service = AnimekoSourceService(dio);
    final sources = await service.subscription(animekoOnlineSubscription);
    stage = 'search';
    final source = sources.firstWhere(
      (source) => source.factoryId == 'json-api',
    );
    final page = await service.search(source, '葬送的芙莉莲');
    final title = page.items.firstWhere((title) => title.title == '葬送的芙莉莲');
    stage = 'lines';
    final lines = await service.lines(source, title.id);
    final episode = lines
        .firstWhere((line) => line.episodes.isNotEmpty)
        .episodes
        .first;
    stage = 'resolve';
    final media = await service.resolve(source, episode);
    stage = 'media-request';
    final manifest = await dio.get<ResponseBody>(
      media.uri.toString(),
      options: Options(
        responseType: ResponseType.stream,
        headers: {...media.headers, 'Range': 'bytes=0-1023'},
      ),
    );
    final firstChunk = await manifest.data!.stream.first.timeout(
      const Duration(seconds: 12),
    );
    final isHls = utf8
        .decode(firstChunk.take(128).toList(), allowMalformed: true)
        .contains('#EXTM3U');
    final isMp4 = ascii
        .decode(firstChunk.take(16).toList(), allowInvalid: true)
        .contains('ftyp');
    final isEbml =
        firstChunk.length >= 4 &&
        firstChunk[0] == 0x1a &&
        firstChunk[1] == 0x45 &&
        firstChunk[2] == 0xdf &&
        firstChunk[3] == 0xa3;
    stdout.writeln(
      jsonEncode({
        'subscriptionSources': sources.length,
        'webSelector': sources
            .where((source) => source.factoryId == 'web-selector')
            .length,
        'jsonApi': sources
            .where((source) => source.factoryId == 'json-api')
            .length,
        'source': source.name,
        'searchTitles': page.items.map((title) => title.title).toList(),
        'lines': lines.length,
        'episodes': lines.fold<int>(
          0,
          (total, line) => total + line.episodes.length,
        ),
        'resolved': true,
        'mediaStatus': manifest.statusCode,
        'hlsManifest': isHls,
        'mediaSignature': isHls
            ? 'hls'
            : isMp4
            ? 'mp4'
            : isEbml
            ? 'ebml'
            : 'unknown',
        'contentType': manifest.headers.value('content-type'),
      }),
    );
    if (!isHls && !isMp4 && !isEbml) {
      throw const FormatException('Unknown media signature');
    }
  } catch (error) {
    stderr.writeln(
      jsonEncode({
        'stage': stage,
        'errorType': error.runtimeType.toString(),
        if (error is DioException) 'httpStatus': error.response?.statusCode,
      }),
    );
    exitCode = 1;
  } finally {
    dio.close(force: true);
  }
}
