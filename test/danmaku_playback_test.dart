import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/danmaku.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/features/playback/playback_view_model.dart';

import 'support/fakes.dart';

class FakeDanmakuRepository implements DanmakuRepository {
  final calls = <int>[];
  final results = <int, Completer<DanmakuResult>>{};
  final saved = <DanmakuOptions>[];
  bool throwError = false;
  DanmakuOptions options = const DanmakuOptions();
  @override
  Future<DanmakuOptions> getOptions() async => options;
  @override
  Future<void> saveOptions(DanmakuOptions value) async {
    saved.add(value);
    options = value;
  }

  @override
  Future<DanmakuResult> load(
    Anime anime,
    Episode episode, {
    DanmakuMatch? selected,
    bool rematch = false,
    Future<void>? cancelled,
  }) async {
    calls.add(episode.id);
    if (throwError) throw const DanmakuException('弹幕鉴权失败');
    return results.putIfAbsent(episode.id, Completer<DanmakuResult>.new).future;
  }
}

void main() {
  late FakeLibrary library;
  late FakeEngine engine;
  late FakeDanmakuRepository danmaku;
  late ProviderContainer container;
  late ProviderSubscription<PlaybackState> listener;
  late PlaybackViewModel vm;
  late PlaybackSession session;
  Future<void> flush() async {
    for (var i = 0; i < 8; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  void open({bool demo = false}) {
    session = (
      subjectId: demo ? 0 : 1,
      episodeId: demo ? 0 : 11,
      isDemo: demo,
      routeKey: Object(),
    );
    container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
        libraryRepositoryProvider.overrideWithValue(library),
        settingsRepositoryProvider.overrideWithValue(FakeSettings()),
        playbackEngineFactoryProvider.overrideWithValue(() => engine),
        danmakuRepositoryProvider.overrideWithValue(danmaku),
      ],
    );
    listener = container.listen(playbackViewModelProvider(session), (_, _) {});
    vm = container.read(playbackViewModelProvider(session).notifier);
  }

  PlaybackState state() => container.read(playbackViewModelProvider(session));
  setUp(() {
    library = FakeLibrary();
    engine = FakeEngine();
    danmaku = FakeDanmakuRepository();
    library.media[11] = PlayableMedia(Uri.parse('https://example.com/1.mp4'));
    open();
  });
  tearDown(() async {
    await vm.close();
    listener.close();
    container.dispose();
    await library.close();
  });

  test(
    'opening a real episode starts automatic danmaku without blocking video',
    () async {
      await vm.initialize();
      await flush();
      expect(engine.opened.length, 1);
      expect(danmaku.calls, [11]);
      expect(state().loading, false);
      expect(state().snapshot.playing, true);
      expect(state().danmakuLoading, true);
      danmaku.results[11]!.complete(
        const DanmakuResult(
          message: 'loaded',
          comments: [DanmakuComment(id: 1, timeMs: 0, text: '自动弹幕')],
        ),
      );
      await flush();
      expect(state().danmaku.comments.single.text, '自动弹幕');
      expect(state().danmakuLoading, false);
    },
  );

  test('danmaku failure is separate from playback error and retry', () async {
    danmaku.throwError = true;
    await vm.initialize();
    await flush();
    expect(state().error, isNull);
    expect(state().danmaku.message, '弹幕鉴权失败');
    expect(state().snapshot.playing, true);
  });

  test(
    'switching episodes ignores the previous episode late response',
    () async {
      library.media[12] = PlayableMedia(Uri.parse('https://example.com/2.mp4'));
      await vm.initialize();
      await flush();
      await vm.playNext();
      await flush();
      expect(danmaku.calls, [11, 12]);
      danmaku.results[12]!.complete(
        const DanmakuResult(
          message: 'next',
          comments: [DanmakuComment(id: 2, timeMs: 0, text: '第二集')],
        ),
      );
      await flush();
      danmaku.results[11]!.complete(
        const DanmakuResult(
          message: 'old',
          comments: [DanmakuComment(id: 1, timeMs: 0, text: '旧集')],
        ),
      );
      await flush();
      expect(state().danmaku.comments.single.text, '第二集');
    },
  );

  test('turning off cancels pending data and persists settings without a video command', () async {
    await vm.initialize();
    await flush();
    await vm.updateDanmakuOptions(
      const DanmakuOptions(enabled: false, offsetMs: 2000),
    );
    danmaku.results[11]!.complete(
      const DanmakuResult(
        message: 'late',
        comments: [DanmakuComment(id: 1, timeMs: 0, text: 'late')],
      ),
    );
    await flush();
    expect(state().danmaku.comments, isEmpty);
    expect(state().danmakuOptions.enabled, false);
    expect(danmaku.saved.single.offsetMs, 2000);
    expect(state().snapshot.playing, true);
  });

  test('stored off preference skips all automatic network work', () async {
    danmaku.options = const DanmakuOptions(enabled: false);
    await vm.initialize();
    await flush();
    expect(danmaku.calls, isEmpty);
    expect(state().danmakuOptions.enabled, false);
  });

  test(
    'demo never requests danmaku and closed players ignore late results',
    () async {
      await vm.initialize();
      await flush();
      await vm.close();
      danmaku.results[11]!.complete(const DanmakuResult(message: 'late'));
      await flush();
      listener.close();
      container.dispose();
      engine = FakeEngine();
      danmaku = FakeDanmakuRepository();
      open(demo: true);
      await vm.initialize();
      await flush();
      expect(danmaku.calls, isEmpty);
    },
  );
}
