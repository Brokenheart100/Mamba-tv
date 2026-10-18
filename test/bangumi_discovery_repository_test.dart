import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/data/repositories/bangumi_discovery_repository.dart';
import 'package:mamba_tv/data/services/bangumi_service.dart';
import 'package:mamba_tv/domain/bangumi_discovery.dart';
import 'package:mamba_tv/domain/failure.dart';

Map<String, dynamic> animeRow(int id) => {
  'id': id,
  'name': 'Anime $id',
  'name_cn': '动画 $id',
  'date': '2026-10-01',
};

void main() {
  late Dio dio;
  late RemoteBangumiDiscoveryRepository repository;
  late List<RequestOptions> requests;
  late Object Function(RequestOptions) payload;
  setUp(() {
    requests = [];
    dio = Dio();
    repository = RemoteBangumiDiscoveryRepository(BangumiService(dio));
    payload = (_) => {
      'total': 1,
      'data': [animeRow(1)],
    };
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: payload(request),
            ),
          );
        },
      ),
    );
  });
  tearDown(() => dio.close(force: true));

  test('calendar preserves cross-day appearances and merges duplicates within each day', () async {
    payload = (_) => [
      {
        'weekday': {'id': 7},
        'items': [animeRow(1)],
      },
      {
        'weekday': {'id': 1},
        'items': [animeRow(1), animeRow(1)],
      },
      {
        'weekday': {'id': 1},
        'items': [animeRow(2)],
      },
    ];
    final days = await repository.calendar();
    expect(days.map((day) => day.weekday), [1, 2, 3, 4, 5, 6, 7]);
    expect(days.first.items.map((anime) => anime.id), [1, 2]);
    expect(days.last.items.single.id, 1);
    expect(days[1].items, isEmpty);
    expect(
      () => days.first.items.add(days.last.items.single),
      throwsUnsupportedError,
    );
    expect(requests.single.path, '/calendar');
  });

  test('quarter uses all three months with exclusive end bound and safe animation filters', () async {
    final page = await repository.browse(
      const BrowseQuery(
        year: 2026,
        quarter: 4,
        order: BrowseOrder.score,
        format: BrowseFormat.movie,
      ),
      offset: 24,
    );
    final request = requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/v0/search/subjects');
    expect(request.queryParameters, {'limit': 24, 'offset': 24});
    expect(request.data['filter'], {
      'type': [2],
      'nsfw': false,
      'air_date': ['>=2026-10-01', '<2027-01-01'],
      'tag': ['剧场版'],
    });
    expect(request.data['sort'], 'score');
    expect(page.items.single.title, '动画 1');
    expect(page.total, 1);
  });

  test('ranking uses official rank endpoint and numeric category; all-years omits year', () async {
    await repository.browse(
      const BrowseQuery(mode: BrowseMode.ranking, format: BrowseFormat.web),
    );
    expect(requests.last.path, '/v0/subjects');
    expect(requests.last.method, 'GET');
    expect(requests.last.queryParameters, {
      'type': 2,
      'sort': 'rank',
      'limit': 24,
      'offset': 0,
      'cat': 5,
    });
    await repository.browse(
      const BrowseQuery(mode: BrowseMode.ranking, year: 2024),
    );
    expect(requests.last.queryParameters['year'], 2024);
    expect(requests.last.queryParameters, isNot(contains('cat')));
  });

  test('relations retain official relation labels, drop non-animation and self links', () async {
    payload = (_) => [
      {
        ...animeRow(2),
        'type': 2,
        'relation': '续集',
        'images': {'large': 'http://example.com/2.jpg'},
      },
      {...animeRow(2), 'type': 2, 'relation': '续集'},
      {...animeRow(1), 'type': 2, 'relation': '本篇'},
      {...animeRow(3), 'type': 1, 'relation': '原作'},
    ];
    final rows = await repository.relations(1);
    expect(rows.length, 1);
    expect(rows.single.relation, '续集');
    expect(rows.single.anime.id, 2);
    expect(rows.single.anime.image, 'https://example.com/2.jpg');
    expect(requests.single.path, '/v0/subjects/1/subjects');
  });

  test('cast reuses inline actors without per-character requests and handles missing images', () async {
    payload = (_) => [
      {
        'id': 8,
        'name': '角色',
        'relation': '主角',
        'images': {'medium': 'http://example.com/8.jpg'},
        'actors': [
          {'id': 9, 'name': '声优'},
        ],
      },
      {'id': 10, 'name': '配角', 'images': null},
    ];
    final rows = await repository.characters(1);
    expect(rows.first.actors.single.name, '声优');
    expect(rows.first.image, 'https://example.com/8.jpg');
    expect(rows.last.image, isEmpty);
    expect(rows.last.actors, isEmpty);
    expect(requests.single.path, '/v0/subjects/1/characters');
  });

  test(
    'malformed DTO becomes a domain failure rather than fabricated data',
    () async {
      payload = (_) => [
        {'id': 'bad id'},
      ];
      await expectLater(repository.characters(1), throwsA(isA<AppFailure>()));
    },
  );
}
