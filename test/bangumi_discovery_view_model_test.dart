import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/bangumi_discovery.dart';
import 'package:mamba_tv/domain/failure.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/features/catalog/discovery_view_models.dart';
import 'package:mamba_tv/presentation/features/detail/subject_extras_view_model.dart';

import 'support/discovery_fake.dart';
import 'support/fakes.dart';

class PendingDiscovery extends FakeDiscovery {
  final pending = <Completer<AnimePage>>[];
  @override
  Future<AnimePage> browse(BrowseQuery query, {int offset = 0}) {
    queries.add((query: query, offset: offset));
    final result = Completer<AnimePage>();
    pending.add(result);
    return result.future;
  }
}

class FailingRelations extends FakeDiscovery {
  @override
  Future<List<RelatedAnime>> relations(int subjectId) async =>
      throw const AppFailure('关系服务失败');
}

Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  test(
    'calendar loads once, changing weekday is local, invalid weekdays ignored',
    () async {
      final repository = FakeDiscovery();
      final container = ProviderContainer(
        overrides: [
          bangumiDiscoveryRepositoryProvider.overrideWithValue(repository),
        ],
      );
      final listener = container.listen(calendarViewModelProvider, (_, _) {});
      addTearDown(() {
        listener.close();
        container.dispose();
      });
      await flush();
      final vm = container.read(calendarViewModelProvider.notifier);
      vm.selectDay(3);
      vm.selectDay(9);
      expect(container.read(calendarViewModelProvider).weekday, 3);
      expect(container.read(calendarViewModelProvider).days.length, 7);
      expect(repository.calendarCalls, 1);
    },
  );

  test('new filter response wins over old requests and disposed requests are ignored', () async {
    final repository = PendingDiscovery();
    final container = ProviderContainer(
      overrides: [
        bangumiDiscoveryRepositoryProvider.overrideWithValue(repository),
      ],
    );
    final listener = container.listen(browseViewModelProvider, (_, _) {});
    await flush();
    final vm = container.read(browseViewModelProvider.notifier);
    final changing = vm.changeMode(BrowseMode.ranking);
    repository.pending[1].complete(const AnimePage([relatedAnime], 1));
    await changing;
    repository.pending[0].complete(const AnimePage([testAnime], 1));
    await flush();
    expect(container.read(browseViewModelProvider).items.single, relatedAnime);
    expect(container.read(browseViewModelProvider).query.year, 0);
    final closing = vm.load(const BrowseQuery(year: 2024));
    listener.close();
    container.dispose();
    repository.pending[2].complete(const AnimePage([], 0));
    await closing;
  });

  test('pagination deduplicates results, advances raw offset, retries retained page', () async {
    final repository = PendingDiscovery();
    final container = ProviderContainer(
      overrides: [
        bangumiDiscoveryRepositoryProvider.overrideWithValue(repository),
      ],
    );
    final listener = container.listen(browseViewModelProvider, (_, _) {});
    addTearDown(() {
      listener.close();
      container.dispose();
    });
    await flush();
    repository.pending[0].complete(const AnimePage([testAnime], 4));
    await flush();
    final vm = container.read(browseViewModelProvider.notifier);
    final firstMore = vm.loadMore();
    await vm.loadMore(); // Concurrent pagination is ignored.
    expect(repository.pending.length, 2);
    repository.pending[1].completeError(const AppFailure('分页失败'));
    await firstMore;
    expect(container.read(browseViewModelProvider).items.single, testAnime);
    expect(container.read(browseViewModelProvider).error, isNotNull);
    final retry = vm.retry();
    expect(repository.queries.last.offset, 1);
    repository.pending[2].complete(
      const AnimePage([testAnime, relatedAnime], 4),
    );
    await retry;
    expect(container.read(browseViewModelProvider).items.length, 2);
    final last = vm.loadMore();
    expect(repository.queries.last.offset, 3);
    repository.pending[3].complete(const AnimePage([], 4));
    await last;
    expect(container.read(browseViewModelProvider).hasMore, false);
  });

  test('relations fail independently while cast remains available', () async {
    final container = ProviderContainer(
      overrides: [
        bangumiDiscoveryRepositoryProvider.overrideWithValue(
          FailingRelations(),
        ),
      ],
    );
    final provider = subjectExtrasViewModelProvider(1);
    final listener = container.listen(provider, (_, _) {});
    addTearDown(() {
      listener.close();
      container.dispose();
    });
    await flush();
    expect(container.read(provider).relations.hasError, true);
    expect(
      container.read(provider).characters.requireValue.single,
      testCharacter,
    );
  });
}
