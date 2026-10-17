import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import 'tv_focus.dart';

class TvShell extends StatelessWidget {
  const TvShell({super.key, required this.child, required this.location});
  final Widget child;
  final String location;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 1050;
      return Scaffold(
        body: SafeArea(
          child: FocusTraversalGroup(
            child: Row(
              children: [
                Container(
                  width: wide ? 190 : 82,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10111B),
                    border: Border(right: BorderSide(color: Color(0xFF242533))),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 16 : 9,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              color: accent,
                              size: 32,
                            ),
                            if (wide)
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'MAMBA',
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          wide ? 'ANIMATION / TV' : 'TV',
                          style: const TextStyle(
                            fontSize: 9,
                            color: muted,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Expanded(
                          child: ListView(
                            children: [
                              for (final item in const [
                                ('/', '发现', Icons.explore_outlined),
                                (
                                  '/categories',
                                  '动漫分类',
                                  Icons.grid_view_rounded,
                                ),
                                ('/search', '搜索', Icons.search_rounded),
                                (
                                  '/library',
                                  '我的追番',
                                  Icons.bookmark_border_rounded,
                                ),
                                ('/history', '观看记录', Icons.history_rounded),
                                ('/settings', '设置', Icons.tune_rounded),
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TvFocus(
                                    selected: location == item.$1,
                                    label: item.$2,
                                    onPressed: () => context.go(item.$1),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: wide
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item.$3,
                                          size: 23,
                                          color: location == item.$1
                                              ? accent
                                              : muted,
                                        ),
                                        if (wide)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 13,
                                            ),
                                            child: Text(
                                              item.$2,
                                              style: TextStyle(
                                                color: location == item.$1
                                                    ? Colors.white
                                                    : muted,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Icon(
                          Icons.settings_remote_outlined,
                          size: 20,
                          color: muted,
                        ),
                        if (wide)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '方向键移动 · 确认键选择',
                              style: TextStyle(fontSize: 10, color: muted),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}
