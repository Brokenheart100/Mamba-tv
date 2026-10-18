import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/domain/danmaku.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/features/playback/danmaku_overlay.dart';

void main() {
  testWidgets(
    'real renderer follows pause, buffering, seek, rate, and visibility',
    (tester) async {
      DanmakuController<DanmakuComment>? controller;
      const comments = [
        DanmakuComment(id: 1, timeMs: 0, text: '第一条'),
        DanmakuComment(id: 2, timeMs: 1000, text: '第二条'),
        DanmakuComment(id: 3, timeMs: 10000, text: '跳转目标'),
      ];
      Future<void> frame({
        int ms = 0,
        bool playing = true,
        bool buffering = false,
        double rate = 1,
        int revision = 0,
        DanmakuOptions options = const DanmakuOptions(),
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DanmakuOverlay(
                comments: comments,
                snapshot: PlaybackSnapshot(
                  position: Duration(milliseconds: ms),
                  playing: playing,
                  buffering: buffering,
                ),
                options: options,
                rate: rate,
                seekRevision: revision,
                onControllerCreated: (value) => controller = value,
              ),
            ),
          ),
        );
        await tester.pump();
      }

      await frame();
      expect(controller!.scrollDanmaku.single.content.text, '第一条');
      await frame(playing: false);
      expect(controller!.running, false);
      await frame(ms: 1000);
      expect(controller!.running, true);
      expect(
        controller!.scrollDanmaku.map((v) => v.content.text),
        contains('第二条'),
      );
      await frame(ms: 1000, buffering: true);
      expect(controller!.running, false);
      await frame(ms: 10000, revision: 1);
      expect(controller!.scrollDanmaku.single.content.text, '跳转目标');
      await frame(ms: 10000, revision: 1, rate: 2);
      expect(controller!.option.duration, 4);
      expect(controller!.option.staticDuration, 2);
      await frame(
        ms: 10000,
        revision: 1,
        rate: 2,
        options: const DanmakuOptions(enabled: false),
      );
      expect(find.byType(DanmakuScreen<DanmakuComment>), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'offset delays comments and overlay lets pointer events reach video controls',
    (tester) async {
      DanmakuController<DanmakuComment>? controller;
      var pressed = 0;
      Future<void> frame(int ms) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () => pressed++,
                      child: const Text('播放按钮'),
                    ),
                  ),
                  DanmakuOverlay(
                    comments: const [
                      DanmakuComment(id: 1, timeMs: 1000, text: '延后弹幕'),
                    ],
                    snapshot: PlaybackSnapshot(
                      position: Duration(milliseconds: ms),
                      playing: true,
                    ),
                    options: const DanmakuOptions(offsetMs: 1000),
                    rate: 1,
                    seekRevision: 0,
                    onControllerCreated: (value) => controller = value,
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
      }

      await frame(1000);
      expect(controller!.scrollDanmaku, isEmpty);
      await tester.tap(find.text('播放按钮'));
      expect(pressed, 1);
      await frame(2000);
      expect(controller!.scrollDanmaku.single.content.text, '延后弹幕');
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );
}
