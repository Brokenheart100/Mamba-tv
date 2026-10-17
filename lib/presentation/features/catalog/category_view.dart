import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../domain/anime_filter.dart';
import '../../core/anime_card.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'catalog_view_model.dart';

const _regions = {
  AnimeRegion.all: '全部',
  AnimeRegion.japan: '日本动画',
  AnimeRegion.china: '国产动画',
  AnimeRegion.western: '欧美动画',
};
const _formats = {
  AnimeFormat.all: '全部',
  AnimeFormat.tv: 'TV',
  AnimeFormat.movie: '剧场版',
  AnimeFormat.ova: 'OVA',
  AnimeFormat.web: 'WEB',
};
const _sorts = {
  AnimeSort.rank: '综合排名',
  AnimeSort.heat: '按热度',
  AnimeSort.score: '按评分',
};
const _genres = [
  '奇幻',
  '热血',
  '搞笑',
  '恋爱',
  '校园',
  '异世界',
  '战斗',
  '后宫',
  '冒险',
  '治愈',
  '穿越',
  '科幻',
  '悬疑',
  '日常',
  '运动',
  '百合',
];

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(categoryViewModelProvider);
    final vm = ref.read(categoryViewModelProvider.notifier);
    final filter = value.filter!;
    final years = {
      0: '全部',
      for (var year = DateTime.now().year; year >= 2000; year--) year: '$year',
      -1: '更早',
    };
    final selected = [
      if (filter.region != AnimeRegion.all) _regions[filter.region]!,
      if (filter.format != AnimeFormat.all) _formats[filter.format]!,
      ?filter.genre,
      if (filter.year != 0) years[filter.year]!,
    ];

    return CustomScrollView(
      key: const PageStorageKey('category-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeading('动漫分类', '选一种心情，发现下一部好故事。'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF303143)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Text(
                            selected.isEmpty
                                ? '已选：全部动漫'
                                : '已选：${selected.join(' · ')}',
                            style: const TextStyle(color: accent),
                          ),
                          TvButton(
                            label: '重置筛选',
                            icon: Icons.restart_alt,
                            onPressed: () =>
                                vm.applyFilter(const AnimeFilter()),
                          ),
                          TvButton(
                            label: _expanded ? '收起筛选' : '展开筛选',
                            icon: _expanded ? Icons.expand_less : Icons.tune,
                            onPressed: () =>
                                setState(() => _expanded = !_expanded),
                          ),
                        ],
                      ),
                      if (_expanded) ...[
                        const SizedBox(height: 12),
                        const Text(
                          '地区、形式与题材按 Bangumi 社区标签匹配，可组合筛选。',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                        _FilterRow<AnimeRegion>(
                          label: '地区',
                          options: _regions,
                          selected: filter.region,
                          autofocus: true,
                          onSelected: (region) =>
                              vm.applyFilter(filter.copyWith(region: region)),
                        ),
                        _FilterRow<AnimeFormat>(
                          label: '形式',
                          options: _formats,
                          selected: filter.format,
                          onSelected: (format) =>
                              vm.applyFilter(filter.copyWith(format: format)),
                        ),
                        _FilterRow<String?>(
                          label: '题材',
                          options: {
                            null: '全部',
                            for (final genre in _genres) genre: genre,
                          },
                          selected: filter.genre,
                          onSelected: (genre) =>
                              vm.applyFilter(filter.copyWith(genre: genre)),
                        ),
                        _FilterRow<int>(
                          label: '年份',
                          options: years,
                          selected: filter.year,
                          onSelected: (year) =>
                              vm.applyFilter(filter.copyWith(year: year)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FilterRow<AnimeSort>(
                  label: '排序',
                  options: _sorts,
                  selected: filter.sort,
                  onSelected: (sort) =>
                      vm.applyFilter(filter.copyWith(sort: sort)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    value.loading
                        ? '正在筛选…'
                        : '匹配 ${value.total} 部 · 已加载 ${value.results.length} 部',
                    style: const TextStyle(color: muted),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (value.loading || value.results.isEmpty)
          SliverToBoxAdapter(
            child: StatusPanel(
              title: value.loading
                  ? '正在查找动漫'
                  : value.error != null
                  ? '筛选未完成'
                  : '没有匹配的动漫',
              message: value.loading ? null : value.error ?? '试试减少筛选条件，或重置筛选。',
              loading: value.loading,
              onRetry: value.error == null ? null : vm.retry,
            ),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 185,
                childAspectRatio: .59,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: value.results.length,
              itemBuilder: (context, index) => AnimeCard(
                key: ValueKey(value.results[index].id),
                anime: value.results[index],
                onPressed: () =>
                    context.push('/anime/${value.results[index].id}'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (value.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        value.error!,
                        style: const TextStyle(color: muted),
                      ),
                    ),
                  if (value.hasMore)
                    TvButton(
                      label: value.loadingMore
                          ? '加载中…'
                          : value.error == null
                          ? '加载更多'
                          : '重试加载',
                      icon: Icons.expand_more,
                      onPressed: value.loadingMore ? null : vm.loadMore,
                    )
                  else
                    const Text('已经到底了', style: TextStyle(color: muted)),
                ],
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/// Material chips supply selection, semantics, pointer and keyboard actions.
class _FilterRow<T> extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.autofocus = false,
  });

  final String label;
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(label, style: const TextStyle(color: muted)),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options.entries)
                Builder(
                  builder: (context) => Focus(
                    skipTraversal: true,
                    canRequestFocus: false,
                    onFocusChange: (focused) {
                      if (focused) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            context.findRenderObject()?.showOnScreen(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
                    child: ChoiceChip(
                      key: ValueKey('$label-${option.value}'),
                      label: Text(option.value),
                      selected: option.key == selected,
                      autofocus: autofocus && option.key == options.keys.first,
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => BorderSide(
                          color: states.contains(WidgetState.focused)
                              ? Colors.white
                              : states.contains(WidgetState.selected)
                              ? accent
                              : const Color(0xFF3C3E51),
                          width: states.contains(WidgetState.focused) ? 3 : 1,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) onSelected(option.key);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
