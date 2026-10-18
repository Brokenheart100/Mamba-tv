import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/providers.dart';
import 'package:mamba_tv/domain/danmaku.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/features/playback/danmaku_panel.dart';
import 'package:mamba_tv/presentation/features/playback/playback_view_model.dart';

import 'danmaku_playback_test.dart' show FakeDanmakuRepository;
import 'support/fakes.dart';

void main() {
  for (final size in const [Size(960, 540), Size(1280, 720)]) {
    testWidgets(
      'TV danmaku panel at $size changes settings by pointer and Select',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final library = FakeLibrary();
        final engine = FakeEngine();
        final repository = FakeDanmakuRepository();
        library.media[11] = PlayableMedia(
          Uri.parse('https://example.com/video.mp4'),
        );
        final PlaybackSession session = (
          subjectId: 1,
          episodeId: 11,
          isDemo: false,
          routeKey: Object(),
        );
        final container = ProviderContainer(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(FakeCatalog()),
            libraryRepositoryProvider.overrideWithValue(library),
            settingsRepositoryProvider.overrideWithValue(FakeSettings()),
            playbackEngineFactoryProvider.overrideWithValue(() => engine),
            danmakuRepositoryProvider.overrideWithValue(repository),
          ],
        );
        final listener = container.listen(
          playbackViewModelProvider(session),
          (_, _) {},
        );
        final vm = container.read(playbackViewModelProvider(session).notifier);
        await vm.initialize();
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(body: DanmakuPanel(session: session)),
            ),
          ),
        );
        await tester.pump();
        repository.results[11]!.complete(
          const DanmakuResult(
            message: '已加载 2 条弹幕',
            candidates: [
              DanmakuMatch(episodeId: 1, animeTitle: '番剧', episodeTitle: '第1话'),
            ],
          ),
        );
        await tester.pump();
        expect(find.text('弹幕设置'), findsOneWidget);
        await tester.ensureVisible(find.text('30'));
        await tester.tap(find.text('30'));
        await tester.pump();
        expect(repository.saved.last.fontSize, 30);
        await tester.ensureVisible(find.text('关闭弹幕'));
        Focus.of(tester.element(find.text('关闭弹幕'))).requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.select);
        await tester.pump();
        expect(repository.saved.last.enabled, false);
        expect(find.text('开启弹幕'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        var closed = false;
        final closing = vm.close().then((_) => closed = true);
        // Stream completion and widget callbacks use real and fake queues.
        for (var i = 0; i < 10 && !closed; i++) {
          await tester.pump(const Duration(milliseconds: 20));
          await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        }
        expect(
          closed,
          true,
          reason:
              'Player cleanup should complete after pumping queued microtasks',
        );
        await closing;
        listener.close();
        container.dispose();
        await library.close();
      },
    );
  }
}
