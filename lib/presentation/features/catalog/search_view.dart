import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/anime_card.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'catalog_view_model.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});
  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _query = TextEditingController();
  bool _searched = false;
  void _search() {
    setState(() => _searched = true);
    ref.read(searchViewModelProvider.notifier).search(_query.text);
    FocusScope.of(context).nextFocus();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading('寻找你的下一部', '按名称搜索番剧，或者留空浏览高分作品。'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _query,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: const InputDecoration(
                    hintText: '输入番剧名称',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              TvButton(
                label: '搜索',
                icon: Icons.arrow_forward,
                onPressed: viewState.loading ? null : _search,
                primary: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: !_searched
                ? const StatusPanel(title: '想看什么？从这里开始。')
                : viewState.loading
                ? const StatusPanel(title: '正在搜索', loading: true)
                : viewState.results.isEmpty
                ? StatusPanel(
                    title: viewState.error == null ? '没有找到匹配的番剧' : '搜索未完成',
                    message: viewState.error,
                    onRetry: viewState.error == null ? null : _search,
                  )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text(
                            '找到 ${viewState.total} 部作品${viewState.error == null ? '' : ' · ${viewState.error}'}',
                          ),
                        ),
                      ),
                      SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 185,
                              childAspectRatio: .59,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: viewState.results.length,
                        itemBuilder: (context, index) => AnimeCard(
                          anime: viewState.results[index],
                          onPressed: () => context.push(
                            '/anime/${viewState.results[index].id}',
                          ),
                        ),
                      ),
                      if (viewState.hasMore)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: TvButton(
                                label: viewState.loadingMore ? '加载中…' : '加载更多',
                                icon: Icons.expand_more,
                                onPressed: viewState.loadingMore
                                    ? null
                                    : vm.loadMore,
                              ),
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
}
