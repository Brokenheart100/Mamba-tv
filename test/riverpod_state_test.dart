import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/presentation/features/catalog/catalog_view_model.dart';
import 'package:mamba_tv/presentation/features/detail/detail_view_model.dart';
import 'package:mamba_tv/presentation/features/library/library_view_model.dart';
import 'package:mamba_tv/presentation/features/playback/playback_view_model.dart';
import 'package:mamba_tv/presentation/features/settings/settings_view_model.dart';

import 'support/fakes.dart';

// ProviderContainer.pump waits for provider rebuilds/disposals. The event turn
// also drains the initial repository futures and async database stream events.
Future<void> flush(ProviderContainer container) async {
  await Future<void>.delayed(Duration.zero);
  await container.pump();
}

void main() {
  test(
    'two routes for the same episode own separate playback engines',
    () async {
      final library = FakeLibrary();
      final engines = <FakeEngine>[];
      final container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
          libraryRepositoryProvider.overrideWithValue(library),
          settingsRepositoryProvider.overrideWithValue(FakeSettings()),
          playbackEngineFactoryProvider.overrideWithValue(() {
            final engine = FakeEngine();
            engines.add(engine);
            return engine;
          }),
        ],
      );
      const firstSession = (
        subjectId: 1,
        episodeId: 11,
        isDemo: false,
        routeKey: 'route-a',
      );
      const secondSession = (
        subjectId: 1,
        episodeId: 11,
        isDemo: false,
        routeKey: 'route-b',
      );
      final first = container.listen(
        playbackViewModelProvider(firstSession),
        (_, _) {},
      );
      final second = container.listen(
        playbackViewModelProvider(secondSession),
        (_, _) {},
      );
      final firstVm = container.read(
        playbackViewModelProvider(firstSession).notifier,
      );
      final secondVm = container.read(
        playbackViewModelProvider(secondSession).notifier,
      );
      addTearDown(() async {
        first.close();
        second.close();
        await firstVm.close();
        await secondVm.close();
        container.dispose();
        await library.close();
      });
      await Future.wait([firstVm.initialize(), secondVm.initialize()]);
      expect(engines.length, 2);
      first.close();
      await flush(container);
      await firstVm.close();
      expect(engines.first.released, true);
      expect(engines.last.released, false);
      expect(container.exists(playbackViewModelProvider(secondSession)), true);
    },
  );

  test(
    'home and search keep independent state in the same container',
    () async {
      final container = ProviderContainer(
        overrides: [catalogRepositoryProvider.overrideWithValue(FakeCatalog())],
      );
      addTearDown(container.dispose);
      final home = container.listen(homeViewModelProvider, (_, _) {});
      final search = container.listen(searchViewModelProvider, (_, _) {});
      addTearDown(home.close);
      addTearDown(search.close);
      await flush(container);
      await container.read(searchViewModelProvider.notifier).search('测试');
      expect(container.read(homeViewModelProvider).feed?.airing, [testAnime]);
      expect(container.read(homeViewModelProvider).query, isEmpty);
      expect(container.read(searchViewModelProvider).query, '测试');
      expect(container.read(searchViewModelProvider).feed, isNull);
    },
  );

  test(
    'favorite commands publish immutable state and update the library stream',
    () async {
      final library = FakeLibrary();
      final container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
          libraryRepositoryProvider.overrideWithValue(library),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await library.close();
      });
      final detail = container.listen(detailViewModelProvider(1), (_, _) {});
      final saved = container.listen(libraryViewModelProvider, (_, _) {});
      addTearDown(detail.close);
      addTearDown(saved.close);
      await flush(container);
      final before = container.read(detailViewModelProvider(1));
      expect(before.anime, testAnime);
      expect(before.favorite, false);
      await container
          .read(detailViewModelProvider(1).notifier)
          .toggleFavorite();
      await flush(container);
      expect(before.favorite, false);
      expect(container.read(detailViewModelProvider(1)).favorite, true);
      expect(container.read(libraryViewModelProvider).favorites, [testAnime]);
      expect(
        () => container.read(libraryViewModelProvider).favorites.clear(),
        throwsUnsupportedError,
      );
      detail.close();
      await flush(container);
      expect(container.exists(detailViewModelProvider(1)), false);
    },
  );

  test(
    'settings reload persisted values after their scope is disposed',
    () async {
      final settings = FakeSettings();
      final container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(settings)],
      );
      addTearDown(container.dispose);
      final first = container.listen(settingsViewModelProvider, (_, _) {});
      await flush(container);
      await container.read(settingsViewModelProvider.notifier).toggleAutoPlay();
      expect(container.read(settingsViewModelProvider).autoPlay, true);
      first.close();
      await flush(container);
      expect(container.exists(settingsViewModelProvider), false);
      final second = container.listen(settingsViewModelProvider, (_, _) {});
      addTearDown(second.close);
      await flush(container);
      expect(container.read(settingsViewModelProvider).autoPlay, true);
      expect(container.read(settingsViewModelProvider).busy, false);
    },
  );
}
