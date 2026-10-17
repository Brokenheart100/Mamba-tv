import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mamba_tv/app/app.dart';
import 'package:mamba_tv/app/dependencies.dart';
import 'package:mamba_tv/data/playback/media_kit_engine.dart';
import 'package:mamba_tv/data/platform/device_environment.dart';
import 'package:media_kit/media_kit.dart';

import '../test/support/fakes.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  testWidgets('Android native video playback, remote pause and disposal', (
    tester,
  ) async {
    final library = FakeLibrary();
    final engine = MediaKitEngine(androidEmulator: await isAndroidEmulator());
    await tester.pumpWidget(
      MambaTvApp(
        initialLocation: '/player-lab',
        dependencies: AppDependencies(
          sources: FakeSources(),
          catalog: FakeCatalog(),
          library: library,
          settings: FakeSettings(),
          createEngine: () => engine,
        ),
      ),
    );
    final deadline = DateTime.now().add(const Duration(seconds: 45));
    while (engine.snapshot.position < const Duration(milliseconds: 300) &&
        DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(engine.snapshot.error, isNull);
    expect(engine.snapshot.duration, greaterThan(Duration.zero));
    expect(engine.snapshot.position, greaterThan(Duration.zero));
    expect(find.text('播放器测试 · Flutter 示例视频'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.mediaPlayPause);
    await tester.pump(const Duration(seconds: 1));
    expect(engine.snapshot.playing, false);
    await engine.controller.waitUntilFirstFrameRendered.timeout(
      const Duration(seconds: 10),
    );
    expect(engine.player.state.width, greaterThan(0));
    expect(engine.player.state.height, greaterThan(0));
    await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 300));
    await binding.takeScreenshot('native-player');
    await tester.tap(find.text('隐藏控制'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('显示控制'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('显示控制'), findsNothing);
    expect(library.saved, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    // Idempotent disposal also waits until all native resources have closed.
    await engine.dispose();
    await library.close();
  });
}
