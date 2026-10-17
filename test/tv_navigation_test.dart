import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/app.dart';
import 'package:mamba_tv/app/dependencies.dart';
import 'package:mamba_tv/app/theme.dart';
import 'package:mamba_tv/presentation/core/tv_focus.dart';

import 'support/fakes.dart';

void main() {
  Future<void> mount(
    WidgetTester tester, {
    String route = '/',
    Size size = const Size(1280, 720),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final library = FakeLibrary();
    addTearDown(library.close);
    await tester.pumpWidget(
      MambaTvApp(
        initialLocation: route,
        dependencies: AppDependencies(
          sources: FakeSources(),
          catalog: FakeCatalog(),
          library: library,
          settings: FakeSettings(),
          createEngine: FakeEngine.new,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final size in [
    const Size(1280, 720),
    const Size(960, 540),
    const Size(640, 360),
  ]) {
    testWidgets('home layout at $size has no overflow', (tester) async {
      await mount(tester, size: size);
      expect(find.text('查看番剧'), findsOneWidget);
      if (size.height >= 540) {
        expect(
          tester.getTopLeft(find.text('发现好故事')).dy,
          greaterThanOrEqualTo(0),
        );
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('D-pad moves focus, select and enter activate TV buttons', (
    tester,
  ) async {
    var first = 0;
    var second = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: tvTheme(),
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TvButton(
                  label: 'first',
                  icon: Icons.play_arrow,
                  autofocus: true,
                  onPressed: () => first++,
                ),
                TvButton(
                  label: 'second',
                  icon: Icons.pause,
                  onPressed: () => second++,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(first, 1);
    expect(second, 1);
  });
  testWidgets('home opens details, favorites update and back restores home', (
    tester,
  ) async {
    await mount(tester);
    await tester.tap(find.text('查看番剧'));
    await tester.pumpAndSettle();
    expect(find.text('选择章节'), findsOneWidget);
    await tester.tap(find.text('加入追番'));
    await tester.pumpAndSettle();
    expect(find.text('已加入追番'), findsOneWidget);
    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();
    expect(find.text('发现好故事'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('search submits text and renders results', (tester) async {
    await mount(tester, route: '/search');
    await tester.enterText(find.byType(TextField), '测试');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('找到 1 部作品'), findsOneWidget);
    expect(find.text('测试番剧'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
