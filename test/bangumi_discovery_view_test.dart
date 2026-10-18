import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/app.dart';
import 'package:mamba_tv/app/dependencies.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/core/anime_card.dart';

import 'support/discovery_fake.dart';
import 'support/fakes.dart';

class RoutedCatalog extends FakeCatalog {
  @override
  Future<Anime> getAnime(int id) async => id == 2 ? relatedAnime : testAnime;
}

void main() {
  Future<FakeDiscovery> mount(
    WidgetTester tester,
    String route,
    Size size,
  ) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final library = FakeLibrary();
    addTearDown(library.close);
    final discovery = FakeDiscovery();
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('discovery-capture'),
        child: MambaTvApp(
          initialLocation: route,
          dependencies: AppDependencies(
            catalog: RoutedCatalog(),
            library: library,
            settings: FakeSettings(),
            createEngine: FakeEngine.new,
            sources: FakeSources(),
            discovery: discovery,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return discovery;
  }

  Future<void> capture(WidgetTester tester, String name) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('discovery-capture')),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      try {
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        final directory = Directory('artifacts/bangumi-discovery-previews');
        await directory.create(recursive: true);
        await File('${directory.path}/$name.png')
            .writeAsBytes(png!.buffer.asUint8List());
      } finally {
        image.dispose();
      }
    });
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final size in [
    const Size(1280, 720),
    const Size(960, 540),
    const Size(640, 360),
  ]) {
    testWidgets('calendar weekday pointer filter and detail return at $size', (
      tester,
    ) async {
      final discovery = await mount(tester, '/calendar', size);
      await tapVisible(tester, find.widgetWithText(ChoiceChip, '星期二'));
      expect(find.text('周2番剧'), findsOneWidget);
      expect(discovery.calendarCalls, 1);
      if (size.width == 1280) await capture(tester, 'calendar');
      await tapVisible(tester, find.byType(AnimeCard).first);
      expect(find.text('系列作品'), findsOneWidget);
      await tapVisible(tester, find.text('返回'));
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '星期二'))
            .selected,
        true,
      );
      expect(discovery.calendarCalls, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('season quarter, format and ranking filters at $size', (
      tester,
    ) async {
      final discovery = await mount(tester, '/browse', size);
      if (size.width == 1280) await capture(tester, 'season');
      await tapVisible(tester, find.widgetWithText(ChoiceChip, '4 月季度'));
      expect(discovery.queries.last.query.quarter, 2);
      await tapVisible(tester, find.widgetWithText(ChoiceChip, '剧场版'));
      expect(discovery.queries.last.query.format.name, 'movie');
      await tapVisible(tester, find.widgetWithText(ChoiceChip, '综合榜单'));
      expect(discovery.queries.last.query.mode.name, 'ranking');
      expect(discovery.queries.last.query.year, 0);
      expect(find.text('全部年份'), findsOneWidget);
      if (size.width == 1280) await capture(tester, 'ranking');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets(
    'year picker updates query and detail return retains browse filters',
    (tester) async {
      final discovery = await mount(tester, '/browse', const Size(960, 540));
      await tapVisible(tester, find.byType(DropdownButtonFormField<int>));
      final year = DateTime.now().year - 1;
      await tester.tap(find.text('$year 年').last);
      await tester.pumpAndSettle();
      expect(discovery.queries.last.query.year, year);
      final count = discovery.queries.length;
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -240));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byType(AnimeCard).first);
      await tapVisible(tester, find.text('返回'));
      expect(discovery.queries.length, count);
      expect(discovery.queries.last.query.year, year);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('D-pad changes weekday through standard Material chip focus', (
    tester,
  ) async {
    await mount(tester, '/calendar', const Size(960, 540));
    final monday = find.widgetWithText(ChoiceChip, '星期一');
    await tester.ensureVisible(monday);
    Focus.of(tester.element(find.text('星期一'))).requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.select);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '星期二'))
          .selected,
      true,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'related animation opens correct route; character dialog lists full voice cast',
    (tester) async {
      final discovery = await mount(tester, '/anime/1', const Size(960, 540));
      await tapVisible(tester, find.text('测试番剧续作'));
      expect(discovery.relationCalls, contains(2));
      expect(find.text('测试番剧续作'), findsOneWidget);
      await tapVisible(tester, find.text('测试角色'));
      expect(find.textContaining('测试声优'), findsWidgets);
      await tapVisible(tester, find.text('关闭'));
      await tapVisible(tester, find.text('返回'));
      expect(find.text('测试番剧'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
