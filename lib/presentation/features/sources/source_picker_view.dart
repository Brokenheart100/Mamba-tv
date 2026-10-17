import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../domain/video_source.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'source_picker_view_model.dart';

class SourcePickerView extends ConsumerStatefulWidget {
  const SourcePickerView({super.key, required this.target});
  final SourceTarget target;
  @override
  ConsumerState<SourcePickerView> createState() => _SourcePickerViewState();
}

class _SourcePickerViewState extends ConsumerState<SourcePickerView> {
  final _query = TextEditingController();
  bool _initialQuery = false;
  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(sourcePickerViewModelProvider(widget.target));
    final vm = ref.read(sourcePickerViewModelProvider(widget.target).notifier);
    if (!_initialQuery && value.anime != null) {
      _query.text = value.query;
      _initialQuery = true;
    }
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(28),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TvButton(
                label: '返回',
                icon: Icons.arrow_back,
                onPressed: () => context.pop(false),
              ),
            ),
            const SizedBox(height: 16),
            PageHeading(
              '选择视频资源',
              value.anime == null
                  ? '正在读取章节…'
                  : '绑定到：${value.anime!.title} · ${value.episode!.title}（${episodeLabel(value.episode!.sort)}）',
            ),
            if (!value.loading &&
                value.sources.isEmpty &&
                value.episode != null) ...[
              const Text('还没有启用的视频源，请更新 Animeko 在线订阅或启用已有数据源。'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TvButton(
                  label: '管理数据源',
                  icon: Icons.dns_outlined,
                  onPressed: () async {
                    await context.push('/sources');
                    if (mounted) await vm.load();
                  },
                ),
              ),
            ],
            if (value.sources.isNotEmpty) ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final source in value.sources)
                    TvButton(
                      label: source.name,
                      icon: source.id == value.source?.id
                          ? Icons.check_circle_outline
                          : Icons.dns_outlined,
                      primary: source.id == value.source?.id,
                      autofocus: source.id == value.source?.id,
                      onPressed: value.saving
                          ? null
                          : () => vm.chooseSource(source),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _query,
                      enabled: !value.saving,
                      textInputAction: TextInputAction.search,
                      onSubmitted: vm.search,
                      decoration: const InputDecoration(
                        labelText: '搜索资源名称',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TvButton(
                    label: '搜索',
                    icon: Icons.search,
                    onPressed: value.saving
                        ? null
                        : () => vm.search(_query.text),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '核对作品、季数和集数后再绑定。Animeko 订阅资源按原规则解析播放地址。',
                  style: TextStyle(color: muted),
                ),
              ),
            ],
            if (value.saving)
              const StatusPanel(title: '正在解析并准备播放，可返回取消', loading: true),
            if (value.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  value.error!,
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ),
            if (value.loading)
              const StatusPanel(title: '正在读取视频源', loading: true)
            else if (value.episode == null)
              StatusPanel(title: '章节读取失败', onRetry: vm.load)
            else if (value.sources.isNotEmpty && value.title == null) ...[
              Text('已找到 ${value.total} 个资源'),
              if (value.results.isEmpty)
                StatusPanel(
                  title: value.error == null ? '没有找到匹配资源' : '搜索未完成',
                  message: '可以修改关键词，或换一个数据源重试。',
                  onRetry: () => vm.search(_query.text),
                ),
              for (final title in value.results)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TvFocus(
                    label: title.title,
                    onPressed: () => vm.chooseTitle(title),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          [
                            title.year,
                            title.category,
                            title.remarks,
                          ].where((text) => text.isNotEmpty).join(' · '),
                          style: const TextStyle(color: muted),
                        ),
                      ],
                    ),
                  ),
                ),
              if (value.page < value.pageCount)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TvButton(
                      label: value.loadingMore ? '加载中…' : '加载更多资源',
                      icon: Icons.expand_more,
                      onPressed: value.loadingMore ? null : vm.loadMore,
                    ),
                  ),
                ),
            ] else if (value.title != null) ...[
              Text(
                '已选资源：${value.title!.title}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TvButton(
                  label: '重新选择作品',
                  icon: Icons.search,
                  onPressed: value.saving ? null : () => vm.search(_query.text),
                ),
              ),
              if (value.lines.isEmpty)
                StatusPanel(
                  title: value.error == null ? '这个资源没有播放线路' : '线路读取失败',
                  onRetry: value.error == null
                      ? null
                      : () => vm.chooseTitle(value.title!),
                ),
              for (final line in value.lines) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(line.name, style: const TextStyle(color: accent)),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final episode in line.episodes)
                      TvButton(
                        label: episode.selectable
                            ? episode.label
                            : '${episode.label} · 暂不支持',
                        icon: episode.selectable
                            ? Icons.play_arrow
                            : Icons.link_off,
                        onPressed: !episode.selectable || value.saving
                            ? null
                            : () => _bind(vm, value, line, episode),
                      ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _bind(
    SourcePickerViewModel vm,
    SourcePickerState value,
    SourceLine line,
    SourceEpisode episode,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认对应章节'),
        content: Text(
          '番剧：${value.anime!.title}\n章节：${value.episode!.title}（${episodeLabel(value.episode!.sort)}）\n\n资源：${value.title!.title}\n线路：${line.name} · ${episode.label}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('解析并播放'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted && await vm.bind(episode) && mounted) {
      context.pop(true);
    }
  }
}
