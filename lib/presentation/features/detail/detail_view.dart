import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../domain/models.dart';
import '../../core/anime_card.dart';
import '../../core/media_dialog.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'detail_view_model.dart';
import 'subject_extras_view.dart';

class DetailView extends ConsumerWidget {
  const DetailView({super.key, required this.subjectId});
  final int subjectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(detailViewModelProvider(subjectId));
    final vm = ref.read(detailViewModelProvider(subjectId).notifier);
    return Scaffold(
      body: SafeArea(
        child: viewState.loading
            ? const StatusPanel(title: '正在加载番剧资料', loading: true)
            : viewState.anime == null
            ? Column(
                children: [
                  TvButton(
                    label: '返回',
                    icon: Icons.arrow_back,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: StatusPanel(
                      title: '资料加载未完成',
                      message: viewState.error,
                      onRetry: vm.load,
                    ),
                  ),
                ],
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(34, 20, 34, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TvButton(
                            label: '返回',
                            icon: Icons.arrow_back,
                            onPressed: () => context.pop(),
                          ),
                          const SizedBox(height: 22),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final content = _Info(
                                vm: vm,
                                viewState: viewState,
                              );
                              final poster = SizedBox(
                                width: 195,
                                height: 275,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimeImage(anime: viewState.anime!),
                                ),
                              );
                              return constraints.maxWidth > 680
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        poster,
                                        const SizedBox(width: 30),
                                        Expanded(child: content),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [content],
                                    );
                            },
                          ),
                          if (viewState.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                viewState.error!,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SubjectExtrasView(subjectId: subjectId),
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(34, 28, 34, 0),
                    sliver: SliverToBoxAdapter(
                      child: PageHeading('选择章节', '选择数据源绑定对应集数，也可以手动设置视频地址。'),
                    ),
                  ),
                  if (viewState.episodes.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(34),
                        child: Text('暂无章节资料'),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(34, 0, 34, 34),
                    sliver: SliverGrid.builder(
                      itemCount: viewState.episodes.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            mainAxisExtent: 162,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) => _EpisodeCard(
                        episode: viewState.episodes[index],
                        vm: vm,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.vm, required this.viewState});
  final DetailState viewState;
  final DetailViewModel vm;
  @override
  Widget build(BuildContext context) {
    final anime = viewState.anime!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(anime.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(anime.originalTitle, style: const TextStyle(color: muted)),
        const SizedBox(height: 12),
        Text(
          '★ ${anime.score.toStringAsFixed(1)}   ·   ${anime.date}   ·   ${anime.episodeCount} 集',
          style: const TextStyle(color: Color(0xFFE8D6A5)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: anime.tags
              .take(5)
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 14),
        Text(
          anime.summary.isEmpty ? '暂无简介' : anime.summary,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFFB9BACB), fontSize: 15),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            if (viewState.episodes.isNotEmpty)
              TvButton(
                label: '开始观看',
                icon: Icons.play_arrow_rounded,
                primary: true,
                autofocus: true,
                onPressed: () => context.push(
                  '/play/${anime.id}/${viewState.episodes.first.id}',
                ),
              ),
            TvButton(
              label: viewState.favorite ? '已加入追番' : '加入追番',
              icon: viewState.favorite
                  ? Icons.bookmark
                  : Icons.bookmark_add_outlined,
              onPressed: viewState.saving ? null : vm.toggleFavorite,
            ),
          ],
        ),
      ],
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({required this.episode, required this.vm});
  final Episode episode;
  final DetailViewModel vm;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: TvFocus(
            label: '播放 ${episode.title}',
            onPressed: () =>
                context.push('/play/${episode.subjectId}/${episode.id}'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${episode.type == 0 ? 'EP' : 'SP ${episode.type}'} ${episodeLabel(episode.sort)}',
                  style: const TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  episode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        TvFocus(
          label: '选择 ${episode.title} 的数据源',
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          onPressed: () async {
            final selected = await context.push<bool>(
              '/sources/select/${episode.subjectId}/${episode.id}',
            );
            if (selected == true && context.mounted) {
              context.push('/play/${episode.subjectId}/${episode.id}');
            }
          },
          child: const Row(
            children: [
              Icon(Icons.dns_outlined, size: 15, color: accent),
              SizedBox(width: 6),
              Text('选择数据源', style: TextStyle(fontSize: 11, color: accent)),
            ],
          ),
        ),
        TvFocus(
          label: '设置 ${episode.title} 的视频地址',
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          onPressed: () async {
            try {
              final address = await vm.mediaAddress(episode);
              if (!context.mounted) return;
              await showMediaDialog(
                context,
                initial: address,
                submitLabel: '保存地址',
                onSave: (value) => vm.bindMedia(episode, value),
              );
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('地址读取失败，请重试')));
              }
            }
          },
          child: const Row(
            children: [
              Icon(Icons.link, size: 15, color: muted),
              SizedBox(width: 6),
              Text('设置视频地址', style: TextStyle(fontSize: 11, color: muted)),
            ],
          ),
        ),
      ],
    ),
  );
}
