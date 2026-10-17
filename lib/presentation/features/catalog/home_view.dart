import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../domain/models.dart';
import '../../core/anime_card.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import '../library/library_view_model.dart';
import 'catalog_view_model.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);
    final history = ref.watch(
      libraryViewModelProvider.select((state) => state.history),
    );
    if (viewState.loading && viewState.feed == null) {
      return const StatusPanel(title: '正在寻找下一段好故事', loading: true);
    }
    if (viewState.error != null && viewState.feed == null) {
      return StatusPanel(
        title: '番剧资料暂时无法加载',
        message: viewState.error,
        onRetry: vm.load,
      );
    }
    final feed = viewState.feed;
    if (feed == null || (feed.airing.isEmpty && feed.popular.isEmpty)) {
      return StatusPanel(title: '暂无番剧资料', onRetry: vm.load);
    }
    final featured = feed.airing.firstOrNull ?? feed.popular.first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
      children: [
        PageHeading(
          '发现好故事',
          '在大屏幕上，留一点时间给喜欢的世界。',
          trailing: TvFocus(
            label: '刷新',
            onPressed: viewState.loading ? null : vm.load,
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.refresh_rounded, color: muted),
          ),
        ),
        _Hero(anime: featured),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 26),
          _Shelf(
            title: '继续观看',
            subtitle: '从上次停下的地方出发',
            items: history.take(12).map((e) => e.anime).toList(),
            subtitles: history
                .take(12)
                .map(
                  (e) =>
                      '第 ${episodeLabel(e.episode.sort)} 集 · ${formatTime(e.position)}',
                )
                .toList(),
            onSelect: (index) => context.push(
              '/play/${history[index].anime.id}/${history[index].episode.id}',
            ),
          ),
        ],
        const SizedBox(height: 26),
        _Shelf(title: '本周放送', subtitle: '这一周的相遇', items: feed.airing),
        const SizedBox(height: 26),
        _Shelf(
          title: '高分佳作',
          subtitle: '来自 Bangumi 的口碑之选',
          items: feed.popular,
        ),
        const SizedBox(height: 24),
        const Text(
          '番剧资料来自 Bangumi · 视频由你选择的媒体地址提供',
          style: TextStyle(fontSize: 11, color: muted),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.anime});
  final Anime anime;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 295,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF242239)),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.sizeOf(context).width * .38,
            child: AnimeImage(anime: anime),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF242239),
                  Color(0xFF242239),
                  Color(0x18242239),
                ],
                stops: [0, .36, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(27),
            child: LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'THIS WEEK / 本周放送',
                      style: TextStyle(
                        color: accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: constraints.maxWidth * .65,
                      child: Text(
                        anime.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${anime.score > 0 ? '★ ${anime.score.toStringAsFixed(1)}   ·   ' : ''}${anime.date}   ·   动画',
                      style: const TextStyle(
                        color: Color(0xFFCDCADB),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    TvButton(
                      label: '查看番剧',
                      icon: Icons.arrow_forward_rounded,
                      primary: true,
                      autofocus: true,
                      onPressed: () => context.push('/anime/${anime.id}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Shelf extends StatelessWidget {
  const _Shelf({
    required this.title,
    required this.subtitle,
    required this.items,
    this.subtitles,
    this.onSelect,
  });
  final String title;
  final String subtitle;
  final List<Anime> items;
  final List<String>? subtitles;
  final void Function(int)? onSelect;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 14),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
        ],
      ),
      const SizedBox(height: 13),
      SizedBox(
        height: 253,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) => SizedBox(
            width: 148,
            child: AnimeCard(
              anime: items[index],
              subtitle: subtitles?[index],
              onPressed: () => onSelect != null
                  ? onSelect!(index)
                  : context.push('/anime/${items[index].id}'),
            ),
          ),
        ),
      ),
    ],
  );
}
