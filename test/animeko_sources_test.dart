import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:mamba_tv/app/logging.dart';
import 'package:mamba_tv/data/repositories/source_repository.dart';
import 'package:mamba_tv/data/services/animeko_source_service.dart';
import 'package:mamba_tv/data/services/animeko_video_matcher.dart';
import 'package:mamba_tv/data/services/maccms_service.dart';
import 'package:mamba_tv/domain/failure.dart';
import 'package:mamba_tv/domain/video_source.dart';

import 'support/animeko_fixture.dart';
import 'support/maccms_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Animeko v2 and legacy subscriptions retain IDs, types and complete rules',
    () {
      final current = AnimekoSourceService.decodeSubscription(
        animekoSubscription(),
        animekoOnlineSubscription,
      );
      final legacy = AnimekoSourceService.decodeSubscription({
        'exportedMediaSourceDataList': {
          'mediaSources': animekoSubscription()['mediaSources'],
        },
      }, animekoOnlineSubscription);
      expect(current, legacy);
      expect(current.first.id, 'animeko:web-selector:test-web');
      expect(current.last.arguments, contains('searchConfig'));
      expect(
        () => AnimekoSourceService.decodeSubscription({
          'schemaVersion': 99,
        }, animekoOnlineSubscription),
        throwsA(isA<AppFailure>()),
      );
    },
  );

  test('first upgrade imports default sources; refresh preserves disabled and custom sources', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final prefs = SharedPreferencesAsync();
    await prefs.setString(
      PreferencesSourceRepository.storageKey,
      jsonEncode([configuredSource.toJson()]),
    );
    final dio = Dio();
    addTearDown(dio.close);
    dynamic payload = animekoSubscription();
    var requests = 0;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests++;
          handler.resolve(
            Response(requestOptions: request, statusCode: 200, data: payload),
          );
        },
      ),
    );
    final repository = PreferencesSourceRepository(
      prefs,
      MacCmsService(dio),
      createAppTalker(console: false),
      animeko: AnimekoSourceService(dio),
    );
    final first = await repository.load();
    expect(first.length, 3);
    expect(first.last, configuredSource);
    await repository.load();
    expect(requests, 1);
    final jsonSource = first.firstWhere(
      (source) => source.factoryId == 'json-api',
    );
    await repository.save(jsonSource.copyWith(enabled: false));
    payload = animekoSubscription(includeWeb: false);
    await repository.importSubscription(animekoOnlineSubscription);
    final updated = await repository.load();
    expect(updated.length, 2);
    expect(updated.first.enabled, false);
    expect(updated.last, configuredSource);
    payload = {'schemaVersion': 99};
    await expectLater(
      repository.importSubscription(animekoOnlineSubscription),
      throwsA(isA<AppFailure>()),
    );
    expect(await repository.load(), updated);
  });

  test(
    'CSS anchor, indexed and JSONPath subjects share original link templates',
    () {
      final anchor = AnimekoSourceService.parseSubjects(
        selectorSource,
        '<div class="results"><a href="/show/7" title="标题">显示文字</a></div>',
      );
      expect(anchor.items.single.title, '标题');
      expect(anchor.items.single.id, 'https://example.com/show/7');
      final cfg = AnimekoSourceService.config(selectorSource);
      final indexed = selectorSource.copyWith(
        arguments: {
          'searchConfig': {
            ...cfg,
            'subjectFormatId': 'indexed',
            'selectorSubjectFormatIndexed': {
              'selectNames': '.name',
              'selectLinks': '.link',
            },
          },
        },
      );
      expect(
        AnimekoSourceService.parseSubjects(
          indexed,
          '<span class="name">作品</span><a class="link" href="/7"></a>',
        ).items.single.id,
        'https://example.com/7',
      );
      final json = selectorSource.copyWith(
        arguments: {
          'searchConfig': {
            ...cfg,
            'subjectFormatId': 'json-path-indexed',
            'selectorSubjectFormatJsonPathIndexed': {
              'selectNames': r'$.list[*].name',
              'selectLinks': r'$.list[*].id',
              'linkTemplate': '/GV{value}/',
            },
          },
        },
      );
      expect(
        AnimekoSourceService.parseSubjects(
          json,
          '{"list":[{"id":7,"name":"作品"}]}',
        ).items.single.id,
        'https://example.com/GV7/',
      );
    },
  );

  test('grouped channels preserve position when regex excludes a line', () {
    final lines = AnimekoSourceService.parseLines(
      selectorSource,
      '<div class="tabs"><span>广告</span><span>主线①</span></div><div class="episodes"><a href="/ad">广告</a></div><div class="episodes"><a href="/play/1">第1集</a></div>',
      'https://example.com/show/7',
    );
    expect(lines.single.name, '主线');
    expect(lines.single.episodes.single.address, 'https://example.com/play/1');
    expect(lines.single.episodes.single.selectable, true);
    final cfg = AnimekoSourceService.config(selectorSource);
    final single = selectorSource.copyWith(
      arguments: {
        'searchConfig': {
          ...cfg,
          'channelFormatId': 'no-channel',
          'selectorChannelFormatNoChannel': {'selectEpisodes': '.episodes a'},
        },
      },
    );
    expect(
      AnimekoSourceService.parseLines(
        single,
        '<div class="episodes"><a href="/play/1">第1集</a></div>',
        'https://example.com/show/7',
      ).single.episodes.length,
      1,
    );
  });

  test('JSON API rule requests escape keywords and resolve only the selected channel', () async {
    final dio = Dio();
    addTearDown(dio.close);
    var matched = true;
    final requests = <RequestOptions>[];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          final dynamic data = switch (options.path) {
            'https://example.com/search' => [
              {'id': 26, 'title': '作品'},
            ],
            'https://example.com/detail' => {
              'sources': [
                {
                  'name': '主线',
                  'episodes': [
                    {'id': 88, 'title': '开篇', 'number': 1},
                  ],
                },
              ],
            },
            _ => {
              'candidates': [
                {'channel': '其他', 'url': 'https://example.com/wrong.m3u8'},
                if (matched)
                  {'channel': '主线', 'url': 'https://example.com/right.m3u8'},
              ],
            },
          };
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: data),
          );
        },
      ),
    );
    final service = AnimekoSourceService(dio);
    final page = await service.search(jsonApiSource, '带"引号');
    expect(requests.first.data, {'term': '带"引号', 'page': 1, 'size': 50});
    expect(requests.first.headers['apikey'], 'fixture-key');
    final lines = await service.lines(jsonApiSource, page.items.single.id);
    final episode = lines.single.episodes.single;
    expect(episode.context['id'], '88');
    expect(
      (await service.resolve(jsonApiSource, episode)).uri.path,
      '/right.m3u8',
    );
    matched = false;
    await expectLater(
      service.resolve(jsonApiSource, episode),
      throwsA(isA<AppFailure>()),
    );
  });

  test('video matcher skips nested parser pages and honors named capture', () {
    final matcher = AnimekoVideoMatcher(selectorSource);
    expect(
      matcher.match(
        'https://example.com/parser?url=https://cdn.example.com/a.m3u8',
      ),
      isNull,
    );
    expect(
      matcher.match('https://cdn.example.com/a.m3u8?token=abc'),
      'https://cdn.example.com/a.m3u8?token=abc',
    );
    expect(
      matcher.match(
        'https://example.com/extract?url=https://cdn.example.com/a.m3u8',
      ),
      'https://cdn.example.com/a.m3u8',
    );
    expect(matcher.match('https://example.com/script.js'), isNull);
  });
  test('source-wide UA overrides legacy playback-only UA without leaking it into page requests', () {
    final cfg = AnimekoSourceService.config(selectorSource);
    final legacy = selectorSource.copyWith(
      arguments: {
        'searchConfig': {
          ...cfg,
          'userAgent': '',
          'matchVideo': {
            'addHeadersToVideo': {'userAgent': 'video-only-UA', 'referer': ''},
          },
        },
      },
    );
    expect(
      AnimekoSourceService.pageHeaders(legacy)['User-Agent'],
      isNot('video-only-UA'),
    );
    expect(
      AnimekoSourceService.videoHeaders(legacy)['User-Agent'],
      'video-only-UA',
    );
    final uniform = legacy.copyWith(
      arguments: {
        'searchConfig': {
          ...AnimekoSourceService.config(legacy),
          'userAgent': 'uniform-UA',
        },
      },
    );
    expect(
      AnimekoSourceService.pageHeaders(uniform)['User-Agent'],
      'uniform-UA',
    );
    expect(
      AnimekoSourceService.videoHeaders(uniform)['User-Agent'],
      'uniform-UA',
    );
    expect(AnimekoSourceService.videoHeaders(uniform)['Referer'], '');
  });
}
