import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/data/services/bangumi_service.dart';
import 'package:mamba_tv/domain/anime_filter.dart';
import 'package:mamba_tv/domain/failure.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/features/catalog/catalog_view_model.dart';

import 'support/fakes.dart';

typedef Request = ({
  AnimeFilter? filter,
  int offset,
  Completer<AnimePage> response,
});

class PendingCatalog extends FakeCatalog {
  final requests = <Request>[];
  @override
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  }) {
    final response = Completer<AnimePage>();
    requests.add((filter: filter, offset: offset, response: response));
    return response.future;
  }
}

void main() {
  test(
    'Bangumi receives combined tags, exclusive year bounds, sort and offset',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://api.bgm.tv'));
      addTearDown(dio.close);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'data': <dynamic>[], 'total': 0},
              ),
            );
          },
        ),
      );
      final api = BangumiService(dio);
      await api.search(
        '',
        24,
        filter: const AnimeFilter(
          region: AnimeRegion.china,
          format: AnimeFormat.movie,
          genre: '奇幻',
          year: 2024,
          sort: AnimeSort.heat,
        ),
      );
      expect(requests.last.path, '/v0/search/subjects');
      expect(requests.last.queryParameters, {'limit': 24, 'offset': 24});
      expect(requests.last.data, {
        'keyword': '',
        'sort': 'heat',
        'filter': {
          'type': [2],
          'nsfw': false,
          'tag': ['中国', '剧场版', '奇幻'],
          'air_date': ['>=2024-01-01', '<2025-01-01'],
        },
      });
      await api.search(
        '',
        0,
        filter: const AnimeFilter(year: -1, sort: AnimeSort.score),
      );
      expect(requests.last.data['filter']['air_date'], ['<2000-01-01']);
      expect(requests.last.data['sort'], 'score');
      await api.search('', 0, filter: const AnimeFilter());
      expect(requests.last.data['filter'], {
        'type': [2],
        'nsfw': false,
      });
      await api.search('芙莉莲', 0);
      expect(requests.last.data['keyword'], '芙莉莲');
      expect(requests.last.data['sort'], 'match');
    },
  );

  test(
    'changing filters discards old pagination and resets the offset',
    () async {
      final repository = PendingCatalog();
      final container = ProviderContainer(
        overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      container.listen(categoryViewModelProvider, (_, _) {});
      await container.pump();
      repository.requests.single.response.complete(
        const AnimePage([testAnime], 10),
      );
      await container.pump();
      final vm = container.read(categoryViewModelProvider.notifier);
      final oldPage = vm.loadMore();
      expect(repository.requests.last.offset, 1);
      const nextFilter = AnimeFilter(
        region: AnimeRegion.china,
        genre: '奇幻',
        year: 2024,
      );
      final latest = vm.applyFilter(nextFilter);
      expect(repository.requests.last.filter, nextFilter);
      expect(repository.requests.last.offset, 0);
      expect(container.read(categoryViewModelProvider).results, isEmpty);
      repository.requests.last.response.complete(const AnimePage([], 0));
      await latest;
      repository.requests[1].response.complete(
        const AnimePage([testAnime], 10),
      );
      await oldPage;
      final state = container.read(categoryViewModelProvider);
      expect(state.filter, nextFilter);
      expect(state.results, isEmpty);
      expect(state.loadingMore, false);
      expect(state.hasMore, false);
    },
  );

  test('pagination retries the same criteria, deduplicates cards and stops on empty pages', () async {
    final repository = PendingCatalog();
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(categoryViewModelProvider, (_, _) {});
    await container.pump();
    repository.requests.single.response.complete(
      const AnimePage([testAnime], 10),
    );
    await container.pump();
    final vm = container.read(categoryViewModelProvider.notifier);
    final failed = vm.loadMore();
    repository.requests.last.response.completeError(const AppFailure('测试网络错误'));
    await failed;
    expect(container.read(categoryViewModelProvider).results, [testAnime]);
    expect(container.read(categoryViewModelProvider).error, '测试网络错误');
    final retry = vm.loadMore();
    expect(repository.requests.last.offset, 1);
    expect(repository.requests.last.filter, const AnimeFilter());
    repository.requests.last.response.complete(
      const AnimePage([testAnime], 10),
    );
    await retry;
    expect(container.read(categoryViewModelProvider).results, [testAnime]);
    final end = vm.loadMore();
    expect(repository.requests.last.offset, 2);
    repository.requests.last.response.complete(const AnimePage([], 10));
    await end;
    expect(container.read(categoryViewModelProvider).hasMore, false);
    expect(
      () => container.read(categoryViewModelProvider).results.clear(),
      throwsUnsupportedError,
    );
  });
}
