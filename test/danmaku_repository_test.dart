import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:mamba_tv/data/services/dandanplay_service.dart';
import 'package:mamba_tv/data/repositories/danmaku_repository.dart';
import 'package:mamba_tv/domain/danmaku.dart';
import 'package:mamba_tv/domain/models.dart';

const targetAnime = Anime(id: 400602, title: '葬送的芙莉莲');
const targetEpisode = Episode(
  id: 100,
  subjectId: 400602,
  title: '冒险结束',
  sort: 1,
);
Map<String, dynamic> commentData() => {
  'count': 4,
  'comments': <Map<String, dynamic>>[
    {'cid': 1, 'p': '1.50,1,16777215,user', 'm': '滚动测试'},
    {'cid': 2, 'p': '0,5,16711680,user', 'm': '顶部测试'},
    {'cid': 3, 'p': '2,4,65280,user', 'm': '底部测试'},
    {'cid': 4, 'p': '1.50,1,16777215,other', 'm': '滚动测试'},
  ],
};
Map<String, dynamic> linkedData({bool duplicate = false}) => {
  'success': true,
  'bangumi': {
    'animeTitle': targetAnime.title,
    'episodes': [
      {
        'episodeId': 123450001,
        'episodeNumber': '1',
        'episodeTitle': '第1话 冒险结束',
      },
      if (duplicate)
        {
          'episodeId': 123460001,
          'episodeNumber': '1',
          'episodeTitle': '第1话 另一季',
          'seasonId': '2',
        },
      {'episodeId': 123459001, 'episodeNumber': 'S1', 'episodeTitle': 'S1 特别篇'},
    ],
  },
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Dio dio;
  late List<RequestOptions> requests;
  late Object Function(RequestOptions) payload;
  late DandanplayService service;
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    requests = [];
    dio = Dio();
    service = DandanplayService(
      dio,
      const DandanplayCredentials('test-app', 'test-secret'),
      now: () =>
          DateTime.fromMillisecondsSinceEpoch(1735660800000, isUtc: true),
    );
    payload = (request) =>
        request.uri.path.contains('/comment/') ? commentData() : linkedData();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final data = payload(request);
          if (data is Response) {
            handler.resolve(data);
          } else {
            handler.resolve(
              Response(requestOptions: request, statusCode: 200, data: data),
            );
          }
        },
      ),
    );
  });
  tearDown(() => dio.close(force: true));

  test(
    'signature uses raw SHA256 bytes, UTC seconds and path without query',
    () async {
      final headers = service.signedHeaders('/api/v2/comment/123450001');
      expect(headers['X-Timestamp'], '1735660800');
      // Independently computed from the documented concatenation with Python hashlib.
      expect(
        headers['X-Signature'],
        '+zIrTiFIrMP4ChXEox5y+T6WJSNPlRYCFZxFXRQc53I=',
      );
      await service.comments(123450001);
      expect(requests.single.headers['X-Signature'], headers['X-Signature']);
      expect(requests.single.headers, isNot(contains('X-AppSecret')));
      expect(requests.single.uri.queryParameters['withRelated'], 'true');
    },
  );

  test(
    '302 CDN fetch strips authentication headers and caches the parsed result',
    () async {
      payload = (request) => request.uri.host == 'api.dandanplay.net'
          ? Response(
              requestOptions: request,
              statusCode: 302,
              headers: Headers.fromMap({
                'location': ['https://cdn.example.test/comments.json'],
              }),
            )
          : commentData();
      final first = await service.comments(123450001);
      final second = await service.comments(123450001);
      expect(first.length, 3);
      expect(second.length, 3);
      expect(requests.length, 2);
      expect(requests.first.headers, contains('X-Signature'));
      expect(
        requests.last.headers.keys.any(
          (key) => key.toLowerCase().startsWith('x-'),
        ),
        false,
      );
    },
  );

  test('rejects unsafe CDN redirect and credentials failures without leaking secrets', () async {
    payload = (request) => Response(
      requestOptions: request,
      statusCode: 302,
      headers: Headers.fromMap({
        'location': ['http://cdn.example.test/comments.json'],
      }),
    );
    await expectLater(
      service.comments(123450001),
      throwsA(isA<DanmakuException>()),
    );
    expect(requests.length, 1);
    payload = (request) => Response(requestOptions: request, statusCode: 403);
    try {
      await service.bangumi(400602);
      fail('Expected authentication failure');
    } on DanmakuException catch (error) {
      expect(error.message, contains('鉴权失败'));
      expect(error.toString(), isNot(contains('test-secret')));
    }
  });

  test(
    'clock skew retries once with server time and retains it for later APIs',
    () async {
      final serverTime = DateTime.utc(2026, 10, 18, 4, 27, 23);
      final expected = (serverTime.millisecondsSinceEpoch ~/ 1000).toString();
      payload = (request) {
        if (requests.length == 1) {
          return Response(
            requestOptions: request,
            statusCode: 403,
            headers: Headers.fromMap({
              'x-error-message': ['Invalid Timestamp'],
              'date': ['Sun, 18 Oct 2026 04:27:23 GMT'],
            }),
          );
        }
        expect(request.headers['X-Timestamp'], expected);
        expect(
          request.headers['X-Signature'],
          isNot(requests.first.headers['X-Signature']),
        );
        return request.uri.path.contains('/comment/')
            ? commentData()
            : linkedData();
      };
      await service.bangumi(400602);
      await service.comments(123450001);
      expect(requests.length, 3);
      expect(requests[1].uri, requests.first.uri);
    },
  );

  test('persistent timestamp rejection stops after one retry', () async {
    payload = (request) => Response(
      requestOptions: request,
      statusCode: 403,
      headers: Headers.fromMap({
        'x-error-message': ['Invalid Timestamp'],
        'date': ['Sun, 18 Oct 2026 04:27:23 GMT'],
      }),
    );
    await expectLater(
      service.bangumi(400602),
      throwsA(
        isA<DanmakuException>().having(
          (e) => e.message,
          'message',
          contains('自动日期和时间'),
        ),
      ),
    );
    expect(requests.length, 2);
  });

  for (final date in <String?>[null, 'invalid-date']) {
    test(
      'timestamp rejection with unusable server date ($date) does not retry',
      () async {
        payload = (request) => Response(
          requestOptions: request,
          statusCode: 403,
          headers: Headers.fromMap({
            'x-error-message': ['Invalid Timestamp'],
            if (date != null) 'date': [date],
          }),
        );
        await expectLater(
          service.bangumi(400602),
          throwsA(
            isA<DanmakuException>().having(
              (e) => e.message,
              'message',
              contains('自动日期和时间'),
            ),
          ),
        );
        expect(requests.length, 1);
      },
    );
  }

  for (final reason in ['Invalid AppId', 'Invalid Signature', 'test-secret']) {
    test(
      'other auth failures ($reason) are sanitized and never clock retried',
      () async {
        payload = (request) => Response(
          requestOptions: request,
          statusCode: 403,
          headers: Headers.fromMap({
            'x-error-message': [reason],
            'date': ['Sun, 18 Oct 2026 04:27:23 GMT'],
          }),
        );
        await expectLater(
          service.bangumi(400602),
          throwsA(
            isA<DanmakuException>()
                .having((e) => e.message, 'message', contains('鉴权失败'))
                .having(
                  (e) => e.message,
                  'safe message',
                  isNot(contains('test-secret')),
                ),
          ),
        );
        expect(requests.length, 1);
      },
    );
  }

  test(
    'CDN timestamp error cannot set the signing clock or trigger retry',
    () async {
      payload = (request) => Response(
        requestOptions: request,
        statusCode: requests.length == 1 ? 302 : 403,
        headers: Headers.fromMap({
          'location': ['https://cdn.example.test/comments.json'],
          'x-error-message': ['Invalid Timestamp'],
          'date': ['Sun, 18 Oct 2026 04:27:23 GMT'],
        }),
      );
      final original = service.signedHeaders('/api/v2/comment/123450001');
      await expectLater(
        service.comments(123450001),
        throwsA(
          isA<DanmakuException>().having(
            (e) => e.message,
            'message',
            contains('加速服务'),
          ),
        ),
      );
      expect(requests.length, 2);
      expect(requests.last.headers, isNot(contains('X-Signature')));
      expect(service.signedHeaders('/api/v2/comment/123450001'), original);
    },
  );

  test(
    'malformed/unsupported comments are skipped, deduplicated and sorted',
    () {
      final data = commentData();
      (data['comments'] as List).addAll(<Map<String, dynamic>>[
        {'p': 'NaN,1,1,u', 'm': 'invalid'},
        {'p': '-1,1,1,u', 'm': 'invalid'},
        {'p': '0,7,1,u', 'm': 'advanced'},
        {'p': '1,1,99999999,u', 'm': 'invalid'},
        {'p': 'broken', 'm': 'invalid'},
        {'p': '1,1,1,u', 'm': '   '},
      ]);
      final values = DandanplayService.parseComments(data);
      expect(values.map((v) => v.timeMs), [0, 1500, 2000]);
      expect(values.map((v) => v.mode), [
        DanmakuMode.top,
        DanmakuMode.scroll,
        DanmakuMode.bottom,
      ]);
      expect(
        DandanplayService.parseComments({'count': 0, 'comments': null}),
        isEmpty,
      );
    },
  );

  test(
    'Bangumi link and a unique numbered episode automatically load comments',
    () async {
      final repository = DandanplayRepository(service);
      final result = await repository.load(targetAnime, targetEpisode);
      expect(result.match?.episodeId, 123450001);
      expect(result.comments.length, 3);
      expect(requests.map((r) => r.uri.path), [
        '/api/v2/bangumi/bgmtv/400602',
        '/api/v2/comment/123450001',
      ]);
    },
  );

  test(
    'duplicate season numbers and specials require explicit confirmation',
    () async {
      payload = (_) => linkedData(duplicate: true);
      final repository = DandanplayRepository(service);
      final ambiguous = await repository.load(targetAnime, targetEpisode);
      expect(ambiguous.match, isNull);
      expect(ambiguous.candidates.length, 3);
      final special = await repository.load(
        targetAnime,
        targetEpisode.copyWith(id: 101, type: 1),
      );
      expect(special.match, isNull);
      expect(requests.any((r) => r.uri.path.contains('/comment/')), false);
    },
  );

  test(
    'title search results are candidates, never an automatic season match',
    () async {
      payload = (request) => request.uri.path.contains('/search/')
          ? {
              'success': true,
              'animes': [
                {
                  'animeTitle': '葬送的芙莉莲 第二季',
                  'episodes': [
                    {'episodeId': 999, 'episodeTitle': '第1话'},
                  ],
                },
              ],
            }
          : {'success': false, 'errorMessage': 'not linked'};
      final result = await DandanplayRepository(service)
          .load(targetAnime, targetEpisode);
      expect(result.match, isNull);
      expect(result.candidates.single.episodeId, 999);
      expect(requests.last.uri.queryParameters['episode'], '1');
    },
  );

  test(
    'confirmed per-episode binding and options survive repository recreation',
    () async {
      final preferences = SharedPreferencesAsync();
      final first = DandanplayRepository(service, preferences);
      const choice = DanmakuMatch(
        episodeId: 123450009,
        animeTitle: '确认作品',
        episodeTitle: '确认集数',
      );
      await first.load(targetAnime, targetEpisode, selected: choice);
      await first.saveOptions(
        const DanmakuOptions(enabled: false, offsetMs: 1000, fontSize: 30),
      );
      requests.clear();
      final second = DandanplayRepository(service, preferences);
      final result = await second.load(targetAnime, targetEpisode);
      expect(result.match?.episodeId, choice.episodeId);
      expect(requests, isEmpty); // Saved identity + service response cache.
      expect((await second.getOptions()).enabled, false);
      expect((await second.getOptions()).offsetMs, 1000);
    },
  );

  test('cancellation is honored even when all API data is cached', () async {
    final repository = DandanplayRepository(service);
    await repository.load(targetAnime, targetEpisode);
    final cancelled = Completer<void>()..complete();
    await expectLater(
      repository.load(targetAnime, targetEpisode, cancelled: cancelled.future),
      throwsA(isA<DioException>()),
    );
  });

  test(
    'rematching replaces an incorrect saved identity with the linked episode',
    () async {
      final repository = DandanplayRepository(service);
      await repository.load(
        targetAnime,
        targetEpisode,
        selected: const DanmakuMatch(
          episodeId: 123450009,
          animeTitle: '手动选择',
          episodeTitle: '另一集',
        ),
      );
      final result = await repository.load(
        targetAnime,
        targetEpisode,
        rematch: true,
      );
      expect(result.match?.episodeId, 123450001);
      expect(result.candidates, isNotEmpty);
    },
  );

  test('unconfigured credentials do not make network requests', () async {
    final repository = DandanplayRepository(
      DandanplayService(dio, const DandanplayCredentials('', '')),
    );
    expect(
      (await repository.load(targetAnime, targetEpisode)).message,
      contains('未配置'),
    );
    expect(requests, isEmpty);
  });

  test(
    'timeline sync skips history on seek, handles rewind and limits bursts',
    () {
      final values = [
        for (var i = 0; i < 100; i++)
          DanmakuComment(id: i, timeMs: i * 1000, text: '$i'),
      ];
      final timeline = DanmakuTimeline(values);
      expect(timeline.advance(0).map((v) => v.id), [0]);
      expect(timeline.advance(1000).map((v) => v.id), [1]);
      expect(timeline.advance(1000), isEmpty);
      expect(timeline.advance(50000).map((v) => v.id), [50]);
      expect(timeline.advance(1000).map((v) => v.id), [1]);
      final dense = DanmakuTimeline([
        for (var i = 0; i < 100; i++)
          DanmakuComment(id: i, timeMs: 0, text: '$i'),
      ]);
      expect(dense.advance(0).length, 16);
      expect(dense.advance(0), isEmpty);
    },
  );
}
