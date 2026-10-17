import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/domain/anime_filter.dart';
import 'package:mamba_tv/presentation/features/catalog/catalog_view_model.dart';

import 'support/fakes.dart';

class DelayedCatalog extends FakeCatalog {
  final requests = <String, Completer<AnimePage>>{};
  @override
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  }) => (requests[keyword] = Completer<AnimePage>()).future;
}

void main() {
  test('an older response cannot replace newer search results', () async {
    final repository = DelayedCatalog();
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(searchViewModelProvider, (_, _) {});
    addTearDown(subscription.close);
    final vm = container.read(searchViewModelProvider.notifier);
    final old = vm.search('old');
    final recent = vm.search('recent');
    repository.requests['recent']!.complete(const AnimePage([testAnime], 1));
    await recent;
    repository.requests['old']!.complete(const AnimePage([], 0));
    await old;
    final state = container.read(searchViewModelProvider);
    expect(state.query, 'recent');
    expect(state.results, [testAnime]);
    expect(state.loading, false);
  });
  test('an outstanding request can finish after disposal', () async {
    final repository = DelayedCatalog();
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
    );
    final subscription = container.listen(searchViewModelProvider, (_, _) {});
    final vm = container.read(searchViewModelProvider.notifier);
    final future = vm.search('pending');
    subscription.close();
    await container.pump();
    expect(container.exists(searchViewModelProvider), false);
    repository.requests['pending']!.complete(const AnimePage([], 0));
    await future;
    container.dispose();
  });
}
