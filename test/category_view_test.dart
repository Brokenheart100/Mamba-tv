import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_tv/app/app.dart';
import 'package:mamba_tv/app/dependencies.dart';
import 'package:mamba_tv/domain/anime_filter.dart';
import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/presentation/core/anime_card.dart';

import 'support/fakes.dart';

class RecordingCatalog extends FakeCatalog {
  final filters = <AnimeFilter?>[];
  @override
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  }) async {
    filters.add(filter);
    return const AnimePage([testAnime], 1);
  }
}

void main() {
  Future<RecordingCatalog> mount(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final catalog = RecordingCatalog();
    final library = FakeLibrary();
    addTearDown(library.close);
    await tester.pumpWidget(
      MambaTvApp(
        initialLocation: '/categories',
        dependencies: AppDependencies(
          sources: FakeSources(),
          catalog: catalog,
          library: library,
          settings: FakeSettings(),
          createEngine: FakeEngine.new,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return catalog;
  }

  Future<void> select(WidgetTester tester, String label, String option) async {
    final chip = find.byKey(ValueKey('$label-$option'));
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(chip).selected, true);
  }

  for (final size in [
    const Size(1280, 720),
    const Size(960, 540),
    const Size(640, 360),
  ]) {
    testWidgets('category layout at $size, pointer filters and reset', (
      tester,
    ) async {
      final catalog = await mount(tester, size);
      await select(tester, '地区', '国产动画');
      await select(tester, '形式', '剧场版');
      await select(tester, '题材', '奇幻');
      await select(tester, '年份', '2024');
      await select(tester, '排序', '按评分');
      expect(
        catalog.filters.last,
        const AnimeFilter(
          region: AnimeRegion.china,
          format: AnimeFormat.movie,
          genre: '奇幻',
          year: 2024,
          sort: AnimeSort.score,
        ),
      );
      await select(tester, '题材', '全部');
      expect(catalog.filters.last!.genre, isNull);
      expect(catalog.filters.last!.region, AnimeRegion.china);
      final reset = find.text('重置筛选');
      await tester.ensureVisible(reset);
      await tester.pumpAndSettle();
      await tester.tap(reset);
      await tester.pumpAndSettle();
      expect(catalog.filters.last, const AnimeFilter());
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets(
    'D-pad selects a Material chip; detail return preserves filters',
    (tester) async {
      final catalog = await mount(tester, const Size(960, 540));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.select);
      await tester.pumpAndSettle();
      expect(catalog.filters.last!.region, AnimeRegion.japan);
      final collapse = find.text('收起筛选');
      await tester.ensureVisible(collapse);
      await tester.pumpAndSettle();
      await tester.tap(collapse);
      await tester.pumpAndSettle();
      final card = find.byType(AnimeCard);
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('选择章节'), findsOneWidget);
      await tester.tap(find.text('返回'));
      await tester.pumpAndSettle();
      expect(find.text('已选：日本动画'), findsOneWidget);
      expect(find.text('展开筛选'), findsOneWidget);
      expect(catalog.filters.length, 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
