import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/app.dart';
import 'package:mamba_tv/app/dependencies.dart';
import 'package:mamba_tv/domain/video_source.dart';

import 'support/fakes.dart';

void main() {
  Future<({FakeSources sources, FakeLibrary library, List<FakeEngine> engines})>
  mount(
    WidgetTester tester, {
    String route = '/settings',
    Size size = const Size(960, 540),
    bool configured = false,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final sources = FakeSources();
    if (configured) {
      sources.sources = [
        const VideoSource(
          id: 'test',
          name: '测试源',
          endpoint: 'https://example.com/api',
        ),
      ];
    }
    final library = FakeLibrary();
    addTearDown(library.close);
    final engines = <FakeEngine>[];
    await tester.pumpWidget(
      MambaTvApp(
        initialLocation: route,
        dependencies: AppDependencies(
          catalog: FakeCatalog(),
          library: library,
          settings: FakeSettings(),
          sources: sources,
          createEngine: () {
            final engine = FakeEngine();
            engines.add(engine);
            return engine;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (sources: sources, library: library, engines: engines);
  }

  for (final size in [const Size(960, 540), const Size(640, 360)]) {
    testWidgets(
      'source editor, persistence command and connection status at $size',
      (tester) async {
        final fixture = await mount(tester, size: size);
        await tester.scrollUntilVisible(
          find.text('数据源管理'),
          200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('数据源管理'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('添加视频源'),
          200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('添加视频源'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('source-name')), '我的源');
        await tester.enterText(
          find.byKey(const Key('source-endpoint')),
          'https://example.com/api.php/provide/vod/',
        );
        await tester.ensureVisible(find.text('保存数据源'));
        await tester.tap(find.text('保存数据源'));
        await tester.pumpAndSettle();
        expect(fixture.sources.sources.single.name, '我的源');
        await tester.scrollUntilVisible(
          find.text('测试连接'),
          200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('测试连接'));
        await tester.pumpAndSettle();
        expect(find.text('连接成功，接口返回有效 JSON 数据'), findsOneWidget);
        await tester.ensureVisible(find.text('已启用'));
        await tester.tap(find.text('已启用'));
        await tester.pumpAndSettle();
        expect(fixture.sources.sources.single.enabled, false);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets(
    'source selection confirms a chapter and opens existing player with that media',
    (tester) async {
      final fixture = await mount(tester, route: '/anime/1', configured: true);
      final choose = find.text('选择数据源').first;
      await tester.ensureVisible(choose);
      await tester.pumpAndSettle();
      await tester.tap(choose);
      await tester.pumpAndSettle();
      expect(find.text('测试番剧资源'), findsOneWidget);
      await tester.ensureVisible(find.text('测试番剧资源'));
      await tester.tap(find.text('测试番剧资源'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('第2集'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('第2集'));
      await tester.pumpAndSettle();
      expect(find.text('确认对应章节'), findsOneWidget);
      expect(fixture.library.media, isEmpty);
      await tester.tap(find.text('解析并播放'));
      await tester.pumpAndSettle();
      expect(fixture.library.media.keys, [11]);
      expect(
        fixture.engines.single.opened.single.uri.toString(),
        'https://example.com/two.mp4',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('settings opens built-in Talker log screen', (tester) async {
    await mount(tester);
    await tester.ensureVisible(find.text('查看应用日志'));
    await tester.tap(find.text('查看应用日志'));
    await tester.pumpAndSettle();
    expect(find.text('应用日志'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
