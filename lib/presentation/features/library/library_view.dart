import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../core/anime_card.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'library_view_model.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key, this.history = false});
  final bool history;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(libraryViewModelProvider);
    final vm = ref.read(libraryViewModelProvider.notifier);
    final ready = history ? viewState.historyReady : viewState.favoritesReady;
    final empty = history
        ? viewState.history.isEmpty
        : viewState.favorites.isEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            history ? '观看记录' : '我的追番',
            history ? '每一个暂停的故事，都可以继续。记录仅保存在本机。' : '把喜欢的故事留在这里。收藏仅保存在本机。',
          ),
          Expanded(
            child: viewState.error != null
                ? StatusPanel(title: '本地记录读取未完成', message: viewState.error)
                : !ready
                ? const StatusPanel(title: '正在读取本地记录', loading: true)
                : empty
                ? StatusPanel(
                    title: history ? '还没有观看记录' : '追番列表还是空的',
                    message: history ? '播放番剧后，会在这里保存观看进度。' : '打开番剧详情，选择「加入追番」。',
                  )
                : history
                ? ListView.separated(
                    itemCount: viewState.history.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = viewState.history[index];
                      final ratio = p.duration.inMilliseconds > 0
                          ? (p.position.inMilliseconds /
                                    p.duration.inMilliseconds)
                                .clamp(0.0, 1.0)
                          : 0.0;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TvFocus(
                                autofocus: index == 0,
                                onPressed: () => context.push(
                                  '/play/${p.anime.id}/${p.episode.id}',
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 62,
                                        height: 85,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: AnimeImage(anime: p.anime),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.anime.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Text(
                                              '第 ${episodeLabel(p.episode.sort)} 集 · ${formatTime(p.position)} / ${formatTime(p.duration)}',
                                              style: const TextStyle(
                                                color: muted,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            LinearProgressIndicator(
                                              value: ratio,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              minHeight: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TvFocus(
                              label: '删除这条观看记录',
                              padding: const EdgeInsets.all(12),
                              onPressed: () => vm.removeHistory(p.episode.id),
                              child: const Icon(
                                Icons.delete_outline,
                                color: muted,
                                size: 21,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    itemCount: viewState.favorites.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 185,
                          childAspectRatio: .59,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) => AnimeCard(
                      anime: viewState.favorites[index],
                      autofocus: index == 0,
                      onPressed: () => context.push(
                        '/anime/${viewState.favorites[index].id}',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
