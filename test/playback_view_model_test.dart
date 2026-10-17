import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/domain/use_cases/prepare_playback.dart';
import 'package:mamba_tv/presentation/features/playback/playback_view_model.dart';

import 'support/fakes.dart';

void main() {
  late FakeLibrary library;
  late FakeEngine engine;
  late PlaybackViewModel vm;
  late ProviderContainer container;
  late ProviderSubscription<PlaybackState> subscription;
  PlaybackSession session = (
    subjectId: 1,
    episodeId: 11,
    isDemo: false,
    routeKey: 'test',
  );
  void createSession({bool demo = false}) {
    session = (
      subjectId: demo ? 0 : 1,
      episodeId: demo ? 0 : 11,
      isDemo: demo,
      routeKey: 'test',
    );
    container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
        libraryRepositoryProvider.overrideWithValue(library),
        settingsRepositoryProvider.overrideWithValue(FakeSettings()),
        playbackEngineFactoryProvider.overrideWithValue(() => engine),
      ],
    );
    subscription = container.listen(
      playbackViewModelProvider(session),
      (_, _) {},
    );
    vm = container.read(playbackViewModelProvider(session).notifier);
  }

  setUp(() {
    library = FakeLibrary();
    engine = FakeEngine();
    createSession();
  });
  tearDown(() async {
    await vm.close();
    subscription.close();
    container.dispose();
    await library.close();
  });
  test(
    'missing source waits for user media and never fabricates a playable URL',
    () async {
      await vm.initialize();
      expect(
        container.read(playbackViewModelProvider(session)).needsMedia,
        true,
      );
      expect(engine.opened, isEmpty);
      await vm.bindAndPlay('https://example.com/1.mp4');
      expect(
        container.read(playbackViewModelProvider(session)).needsMedia,
        false,
      );
      expect(engine.opened.single.uri.path, '/1.mp4');
    },
  );
  test('save progress on close and release the engine', () async {
    library.media[11] = parseMediaAddress('https://example.com/1.mp4');
    await vm.initialize();
    engine.emit(
      const PlaybackSnapshot(
        position: Duration(minutes: 7),
        duration: Duration(minutes: 24),
        playing: true,
      ),
    );
    await vm.close();
    expect(library.saved.last.position, const Duration(minutes: 7));
    expect(engine.released, true);
  });
  test('next episode with no binding stops and requests a source', () async {
    library.media[11] = parseMediaAddress('https://example.com/1.mp4');
    await vm.initialize();
    await vm.playNext();
    expect(
      container.read(playbackViewModelProvider(session)).episode,
      nextEpisode,
    );
    expect(container.read(playbackViewModelProvider(session)).needsMedia, true);
    expect(engine.opened.length, 1);
    expect(library.saved.last.episode.id, 11);
  });
  test('demo playback does not save into anime history', () async {
    await vm.close();
    subscription.close();
    container.dispose();
    engine = FakeEngine();
    createSession(demo: true);
    await vm.initialize();
    engine.emit(
      const PlaybackSnapshot(
        position: Duration(seconds: 4),
        duration: Duration(seconds: 5),
        playing: true,
      ),
    );
    await vm.save();
    await vm.close();
    expect(library.saved, isEmpty);
  });
  test(
    'last listener removal saves progress and releases the native engine',
    () async {
      library.media[11] = parseMediaAddress('https://example.com/1.mp4');
      await vm.initialize();
      engine.emit(
        const PlaybackSnapshot(
          position: Duration(minutes: 3),
          duration: Duration(minutes: 24),
        ),
      );
      subscription.close();
      await container.pump();
      await vm.close();
      expect(container.exists(playbackViewModelProvider(session)), false);
      expect(library.saved.last.position, const Duration(minutes: 3));
      expect(engine.released, true);
    },
  );
}
