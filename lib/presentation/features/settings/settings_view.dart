import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'settings_view_model.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(settingsViewModelProvider);
    final vm = ref.read(settingsViewModelProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
      children: [
        const PageHeading('让观看更合心意', 'Mamba Animation · Android TV'),
        TvFocus(
          autofocus: true,
          onPressed: viewState.busy ? null : vm.toggleAutoPlay,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(Icons.skip_next_outlined, color: accent),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('自动播放下一集'),
                    Text(
                      '仅播放已设置地址的章节；缺少地址时会等待你选择。',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
              Text(
                viewState.autoPlay ? '已开启' : '已关闭',
                style: const TextStyle(color: accent),
              ),
            ],
          ),
        ),
        if (viewState.error != null)
          Text(
            viewState.error!,
            style: const TextStyle(color: Colors.orangeAccent),
          ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '遥控器操作',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(
                '方向键：移动焦点\n确认键：选择或执行\n返回键：回到上一页\n播放页：选择快进 / 快退按钮调整 10 秒，播放键或空格切换暂停',
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        TvButton(
          label: '数据源管理',
          icon: Icons.dns_outlined,
          onPressed: () => context.push('/sources'),
        ),
        const SizedBox(height: 12),
        TvButton(
          label: '查看应用日志',
          icon: Icons.receipt_long_outlined,
          onPressed: () => context.push('/logs'),
        ),
        const SizedBox(height: 22),
        TvButton(
          label: '打开播放器测试',
          icon: Icons.science_outlined,
          onPressed: () => context.push('/player-lab'),
        ),
        const SizedBox(height: 10),
        const Text(
          '使用 Flutter 官方示例视频。测试不会写入番剧观看记录。',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 28),
        const Text(
          'v0.1.0 · MVVM + Clean Architecture\n支持 Bangumi 目录、Animeko 在线源订阅、本机收藏与历史、视频播放和 Talker 日志。\n在线弹幕、账号同步、离线下载和 BT 尚未实现。',
          style: TextStyle(fontSize: 12, color: muted),
        ),
      ],
    );
  }
}
