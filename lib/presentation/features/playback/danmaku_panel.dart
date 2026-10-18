import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/danmaku.dart';
import '../../core/tv_focus.dart';
import 'playback_view_model.dart';

class DanmakuPanel extends ConsumerWidget {
  const DanmakuPanel({super.key, required this.session});
  final PlaybackSession session;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackViewModelProvider(session));
    final vm = ref.read(playbackViewModelProvider(session).notifier);
    final options = state.danmakuOptions;
    void update(DanmakuOptions value) =>
        unawaited(vm.updateDanmakuOptions(value));
    Widget choices<T>(
      String title,
      List<T> values,
      T selected,
      String Function(T) label,
      void Function(T) onSelected,
    ) => Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                ChoiceChip(
                  label: Text(label(value)),
                  selected: selected == value,
                  onSelected: (_) => onSelected(value),
                ),
            ],
          ),
        ],
      ),
    );
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        child: SizedBox(
          width: 740,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FocusTraversalGroup(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '弹幕设置',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '弹幕由弹弹play提供 · ${state.danmakuLoading ? '正在加载…' : state.danmaku.message}',
                  ),
                  if (state.danmaku.match case final match?)
                    Text('${match.animeTitle} · ${match.episodeTitle}'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      TvButton(
                        label: options.enabled ? '关闭弹幕' : '开启弹幕',
                        icon: options.enabled
                            ? Icons.subtitles_off_outlined
                            : Icons.subtitles_outlined,
                        autofocus: true,
                        onPressed: () =>
                            update(options.copyWith(enabled: !options.enabled)),
                      ),
                      TvButton(
                        label: '重新匹配',
                        icon: Icons.refresh,
                        onPressed: state.danmakuLoading
                            ? null
                            : () => unawaited(vm.loadDanmaku(rematch: true)),
                      ),
                      TvButton(
                        label: '完成',
                        icon: Icons.check,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  choices<double>(
                    '透明度',
                    const [.4, .6, .8, 1],
                    options.opacity,
                    (v) => '${(v * 100).round()}%',
                    (v) => update(options.copyWith(opacity: v)),
                  ),
                  choices<double>(
                    '字号',
                    const [18, 24, 30, 36],
                    options.fontSize,
                    (v) => '${v.round()}',
                    (v) => update(options.copyWith(fontSize: v)),
                  ),
                  choices<double>(
                    '显示区域',
                    const [.25, .5, .75, 1],
                    options.area,
                    (v) => '${(v * 100).round()}%',
                    (v) => update(options.copyWith(area: v)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '时间偏移：${(options.offsetMs / 1000).toStringAsFixed(1)} 秒（正数延后）',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TvButton(
                        label: '提前 1 秒',
                        icon: Icons.remove,
                        onPressed: () => update(
                          options.copyWith(offsetMs: options.offsetMs - 1000),
                        ),
                      ),
                      TvButton(
                        label: '延后 1 秒',
                        icon: Icons.add,
                        onPressed: () => update(
                          options.copyWith(offsetMs: options.offsetMs + 1000),
                        ),
                      ),
                      TvButton(
                        label: '重置偏移',
                        icon: Icons.restore,
                        onPressed: () => update(options.copyWith(offsetMs: 0)),
                      ),
                    ],
                  ),
                  if (state.danmaku.candidates.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    const Text('确认 / 更换本集弹幕库'),
                    const Text('仅为当前章节保存选择；不会自动绑定整季。'),
                    const SizedBox(height: 8),
                    for (final candidate in state.danmaku.candidates.take(100))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TvButton(
                          label:
                              '${candidate.animeTitle} · ${candidate.episodeTitle}',
                          icon:
                              state.danmaku.match?.episodeId ==
                                  candidate.episodeId
                              ? Icons.check_circle
                              : Icons.subtitles_outlined,
                          onPressed: state.danmakuLoading
                              ? null
                              : () => unawaited(
                                  vm.loadDanmaku(selected: candidate),
                                ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
