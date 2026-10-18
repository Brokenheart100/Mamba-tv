import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../domain/bangumi_discovery.dart';
import '../../../domain/models.dart';
import '../../core/anime_card.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'discovery_view_models.dart';

const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
const _formatLabels = {
  BrowseFormat.all: '全部形式',
  BrowseFormat.tv: 'TV',
  BrowseFormat.movie: '剧场版',
  BrowseFormat.ova: 'OVA',
  BrowseFormat.web: 'WEB',
};

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(calendarViewModelProvider);
    final vm = ref.read(calendarViewModelProvider.notifier);
    final items =
        value.days
            .where((day) => day.weekday == value.weekday)
            .firstOrNull
            ?.items ??
        <Anime>[];
    return CustomScrollView(
      key: const PageStorageKey('broadcast-calendar'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeading(
                  '新番周历',
                  '按 Bangumi 放送星期浏览，实际视频更新时间以所选数据源为准。',
                  trailing: IconButton(
                    tooltip: '刷新周历',
                    onPressed: value.loading ? null : vm.load,
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var day = 1; day <= 7; day++)
                      ChoiceChip(
                        label: Text(weekdays[day - 1]),
                        selected: value.weekday == day,
                        autofocus: value.weekday == day,
                        onSelected: (_) => vm.selectDay(day),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '${weekdays[value.weekday - 1]} · ${items.length} 部作品',
                  style: const TextStyle(color: muted),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (value.error != null)
          SliverToBoxAdapter(
            child: StatusPanel(
              title: '周历加载失败',
              message: value.error,
              onRetry: vm.load,
            ),
          ),
        if (value.loading && value.days.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: StatusPanel(title: '正在加载周历', loading: true),
          )
        else if (items.isEmpty && value.error == null)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: StatusPanel(title: '这一天暂无放送资料'),
          )
        else
          _AnimeGrid(items: items),
      ],
    );
  }
}

class BrowseView extends ConsumerWidget {
  const BrowseView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(browseViewModelProvider);
    final vm = ref.read(browseViewModelProvider.notifier);
    final query = value.query;
    final season = query.mode == BrowseMode.season;
    final now = DateTime.now();
    // Include any previously selected year even after the wall clock changes.
    final years = {
      for (var year = now.year + 1; year >= 1970; year--) year,
      if (query.year > 0) query.year,
    }.toList()..sort((a, b) => b.compareTo(a));
    return CustomScrollView(
      key: const PageStorageKey('season-ranking'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeading('新番与榜单', '按季度发现新作，或回顾 Bangumi 综合排名。'),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('季度新番'),
                      selected: season,
                      autofocus: true,
                      onSelected: (_) => vm.changeMode(BrowseMode.season),
                    ),
                    ChoiceChip(
                      label: const Text('综合榜单'),
                      selected: !season,
                      onSelected: (_) => vm.changeMode(BrowseMode.ranking),
                    ),
                    SizedBox(
                      width: 184,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        key: ValueKey(('browse-year', query.year, query.mode)),
                        initialValue: query.year,
                        decoration: const InputDecoration(labelText: '首播年份'),
                        items: [
                          if (!season)
                            const DropdownMenuItem(
                              value: 0,
                              child: Text('全部年份'),
                            ),
                          for (final year in years)
                            DropdownMenuItem(
                              value: year,
                              child: Text('$year 年'),
                            ),
                        ],
                        onChanged: (year) {
                          if (year != null) vm.load(query.copyWith(year: year));
                        },
                      ),
                    ),
                  ],
                ),
                if (season) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (var quarter = 1; quarter <= 4; quarter++)
                        ChoiceChip(
                          label: Text('${(quarter - 1) * 3 + 1} 月季度'),
                          selected: query.quarter == quarter,
                          onSelected: (_) =>
                              vm.load(query.copyWith(quarter: quarter)),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final entry in _formatLabels.entries)
                      ChoiceChip(
                        label: Text(entry.value),
                        selected: query.format == entry.key,
                        onSelected: (_) =>
                            vm.load(query.copyWith(format: entry.key)),
                      ),
                  ],
                ),
                if (season) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final entry in const {
                        BrowseOrder.heat: '按热度',
                        BrowseOrder.rank: '按排名',
                        BrowseOrder.score: '按评分',
                      }.entries)
                        ChoiceChip(
                          label: Text(entry.value),
                          selected: query.order == entry.key,
                          onSelected: (_) =>
                              vm.load(query.copyWith(order: entry.key)),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  season
                      ? '${query.year} 年 ${(query.quarter - 1) * 3 + 1}—${query.quarter * 3} 月 · 共 ${value.total} 部作品'
                      : '${query.year == 0 ? '全部年份' : '${query.year} 年'} · 综合排名 · 共 ${value.total} 部作品',
                  style: const TextStyle(color: muted),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (value.loading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: StatusPanel(title: '正在加载番剧', loading: true),
          )
        else if (value.items.isEmpty && value.error == null)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: StatusPanel(title: '当前条件下暂无作品'),
          )
        else
          _AnimeGrid(items: value.items),
        if (value.error != null)
          SliverToBoxAdapter(
            child: StatusPanel(
              title: '番剧加载失败',
              message: value.error,
              onRetry: vm.retry,
            ),
          )
        else if (value.hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: TvButton(
                  label: value.loadingMore ? '正在加载更多' : '加载更多',
                  icon: Icons.expand_more,
                  onPressed: value.loadingMore ? null : vm.loadMore,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AnimeGrid extends StatelessWidget {
  const _AnimeGrid({required this.items});
  final List<Anime> items;
  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
    sliver: SliverGrid.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        mainAxisExtent: 285,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) => AnimeCard(
        key: ValueKey(items[index].id),
        anime: items[index],
        onPressed: () => context.push('/anime/${items[index].id}'),
      ),
    ),
  );
}
