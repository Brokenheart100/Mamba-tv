import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../domain/video_source.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import '../../core/error_message.dart';
import 'sources_view_model.dart';
import 'subscription_editor.dart';

class SourcesView extends ConsumerWidget {
  const SourcesView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sourcesViewModelProvider);
    final vm = ref.read(sourcesViewModelProvider.notifier);
    Future<void> run(Future<void> Function() action) async {
      try {
        await action();
      } catch (_) {
        /* ViewModel displays the failure. */
      }
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
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: 18),
            const PageHeading('数据源管理', '沿用 Animeko 的在线数据源订阅与解析规则。'),
            const ListTile(
              leading: Icon(Icons.info_outline, color: accent),
              title: Text('Bangumi · 番剧资料'),
              subtitle: Text('已启用 · 提供目录、分类、评分和章节，不提供视频。'),
            ),
            const Divider(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                TvButton(
                  label: '更新 Animeko 数据源',
                  icon: Icons.sync,
                  primary: true,
                  autofocus: true,
                  onPressed: state.loading || state.busy
                      ? null
                      : () => run(
                          () =>
                              vm.importSubscription(animekoOnlineSubscription),
                        ),
                ),
                TvButton(
                  label: '添加订阅',
                  icon: Icons.playlist_add,
                  onPressed: state.loading || state.busy
                      ? null
                      : () => showDialog<void>(
                          context: context,
                          builder: (_) =>
                              SubscriptionEditor(onSave: vm.importSubscription),
                        ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '默认订阅与 Animeko 相同：creamycake ani-subs。首次进入会获取在线源，更新时保留启停状态；番剧章节中可选择源、线路与集数。',
                style: TextStyle(color: muted),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TvButton(
                label: '添加视频源',
                icon: Icons.add,
                onPressed: state.loading || state.busy
                    ? null
                    : () => _edit(context, vm),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '也保留自定义 MacCMS JSON 接口，作为可选扩展。',
                style: TextStyle(color: muted),
              ),
            ),
            if (state.loading) const LinearProgressIndicator(),
            if (state.error != null)
              StatusPanel(
                title: '数据源操作未完成',
                message: state.error,
                onRetry: state.sources.isEmpty ? vm.load : null,
              ),
            if (state.message != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  state.message!,
                  style: const TextStyle(color: accent),
                ),
              ),
            if (!state.loading && state.error == null && state.sources.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '没有在线数据源。请更新 Animeko 订阅或添加自己的订阅。',
                  style: TextStyle(color: muted),
                ),
              ),
            for (final source in state.sources)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${Uri.tryParse(source.endpoint)?.host ?? ''} · ${source.factoryId == 'maccms'
                            ? 'MacCMS 扩展'
                            : source.factoryId == 'json-api'
                            ? 'Animeko JSON API · T${source.tier}'
                            : 'Animeko 网页规则 · T${source.tier}'}',
                        style: const TextStyle(color: muted),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          TvButton(
                            label: source.enabled ? '已启用' : '已停用',
                            icon: source.enabled
                                ? Icons.check_circle_outline
                                : Icons.pause_circle_outline,
                            onPressed: state.busy
                                ? null
                                : () => run(
                                    () => vm.save(
                                      source.copyWith(enabled: !source.enabled),
                                    ),
                                  ),
                          ),
                          TvButton(
                            label: '测试连接',
                            icon: Icons.network_check,
                            onPressed: state.busy
                                ? null
                                : () => run(() => vm.check(source)),
                          ),
                          if (source.factoryId == 'maccms')
                            TvButton(
                              label: '编辑',
                              icon: Icons.edit_outlined,
                              onPressed: state.busy
                                  ? null
                                  : () => _edit(context, vm, source),
                            ),
                          TvButton(
                            label: '删除',
                            icon: Icons.delete_outline,
                            onPressed: state.busy
                                ? null
                                : () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('删除 ${source.name}？'),
                                        content: const Text(
                                          '已绑定到章节的视频地址仍保留在本机。',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('删除'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await run(() => vm.remove(source));
                                    }
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    SourcesViewModel vm, [
    VideoSource? source,
  ]) => showDialog<void>(
    context: context,
    builder: (_) => _SourceEditor(source: source, onSave: vm.save),
  );
}

class _SourceEditor extends StatefulWidget {
  const _SourceEditor({this.source, required this.onSave});
  final VideoSource? source;
  final Future<void> Function(VideoSource) onSave;
  @override
  State<_SourceEditor> createState() => _SourceEditorState();
}

class _SourceEditorState extends State<_SourceEditor> {
  late final _name = TextEditingController(text: widget.source?.name ?? '');
  late final _endpoint = TextEditingController(
    text: widget.source?.endpoint ?? '',
  );
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _endpoint.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(
        VideoSource(
          id:
              widget.source?.id ??
              DateTime.now().microsecondsSinceEpoch.toString(),
          name: _name.text.trim(),
          endpoint: _endpoint.text.trim(),
          enabled: widget.source?.enabled ?? true,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorMessage(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.source == null ? '添加 MacCMS 视频源' : '编辑视频源'),
    content: SizedBox(
      width: 580,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('source-name'),
              controller: _name,
              autofocus: true,
              enabled: !_saving,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: '名称',
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('source-endpoint'),
              controller: _endpoint,
              enabled: !_saving,
              keyboardType: TextInputType.url,
              maxLength: 8192,
              decoration: const InputDecoration(
                labelText: 'HTTPS JSON 接口地址',
                hintText: 'https://你的域名/api.php/provide/vod/',
                counterText: '',
              ),
            ),
            const SizedBox(height: 14),
            const Text('填写完整接口地址，保存后可以测试连接。', style: TextStyle(color: muted)),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TvButton(
        label: '取消',
        icon: Icons.close,
        onPressed: _saving ? null : () => Navigator.pop(context),
      ),
      TvButton(
        label: _saving ? '保存中…' : '保存数据源',
        icon: Icons.save_outlined,
        onPressed: _saving ? null : _save,
      ),
    ],
  );
}
