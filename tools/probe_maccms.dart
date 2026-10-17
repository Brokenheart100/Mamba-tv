import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mamba_tv/data/services/maccms_service.dart';
import 'package:mamba_tv/domain/video_source.dart';

import '../test/support/maccms_fixture.dart';

/// Without arguments this is a local protocol check, not a public-source test.
/// With an endpoint and keyword it checks a user-supplied live API.
Future<void> main(List<String> args) async {
  HttpServer? server;
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  try {
    String endpoint;
    if (args.isEmpty) {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        final query = request.uri.queryParameters;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(
            query['ac'] == 'detail'
                ? macCmsDetail()
                : macCmsList(page: int.tryParse(query['pg'] ?? '') ?? 1),
          ),
        );
        await request.response.close();
      });
      endpoint = 'http://127.0.0.1:${server.port}/api.php/provide/vod/';
    } else {
      endpoint = args.first;
    }
    final source = VideoSource(id: 'probe', name: '协议验证', endpoint: endpoint);
    final service = MacCmsService(dio);
    await service.check(source);
    final page = await service.search(source, args.length > 1 ? args[1] : '示例');
    final next = page.page < page.pageCount
        ? await service.search(
            source,
            args.length > 1 ? args[1] : '示例',
            page: page.page + 1,
          )
        : null;
    final lines = page.items.isEmpty
        ? <SourceLine>[]
        : await service.lines(source, page.items.first.id);
    stdout.writeln(
      jsonEncode({
        'mode': args.isEmpty
            ? 'local-contract-fixture'
            : 'user-supplied-live-api',
        'total': page.total,
        'firstPage': page.items.length,
        'nextPage': next?.items.length ?? 0,
        'lines': lines.length,
        'directEpisodes': lines
            .expand((line) => line.episodes)
            .where((episode) => episode.directlyPlayable)
            .length,
      }),
    );
  } catch (error) {
    stderr.writeln('MacCMS probe failed: ${error.runtimeType}');
    exitCode = 1;
  } finally {
    dio.close(force: true);
    await server?.close(force: true);
  }
}
