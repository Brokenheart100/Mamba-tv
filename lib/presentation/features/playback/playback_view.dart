import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/theme.dart';
import '../../../data/playback/media_kit_engine.dart';
import '../../core/media_dialog.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'playback_view_model.dart';

class PlaybackView extends ConsumerStatefulWidget {
  const PlaybackView({super.key, required this.session});
  final PlaybackSession session;
  @override
  ConsumerState<PlaybackView> createState() => _PlaybackViewState();
}

class _PlaybackViewState extends ConsumerState<PlaybackView>
    with WidgetsBindingObserver {
  PlaybackViewModel? _vm;
  bool _leaving = false;
  bool _controls = true;
  bool _awake = false;
  Future<void> _wakeWork = Future.value();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _syncWakeLock(PlaybackState value) {
    final awake = value.snapshot.playing && value.snapshot.error == null;
    if (awake == _awake) return;
    _awake = awake;
    _wakeWork = _wakeWork
        .then((_) => WakelockPlus.toggle(enable: awake))
        .catchError((Object _) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_vm?.suspend());
    }
  }

  Future<void> _exit() async {
    if (_leaving) return;
    _leaving = true;
    await _vm!.close();
    if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(
      _wakeWork.then((_) => WakelockPlus.disable()).catchError((Object _) {}),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(playbackViewModelProvider(widget.session));
    final vm = ref.read(playbackViewModelProvider(widget.session).notifier);
    _vm = vm;
    ref.listen(
      playbackViewModelProvider(widget.session),
      (_, next) => _syncWakeLock(next),
    );
    final state = viewState.snapshot;
    final engine = vm.engine;
    final problem = viewState.error ?? state.error;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exit();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.mediaPlayPause):
                _TogglePlaybackIntent(),
            SingleActivator(LogicalKeyboardKey.mediaFastForward): _SeekIntent(
              10,
            ),
            SingleActivator(LogicalKeyboardKey.mediaRewind): _SeekIntent(-10),
          },
          child: Actions(
            actions: {
              _TogglePlaybackIntent: CallbackAction<_TogglePlaybackIntent>(
                onInvoke: (_) {
                  vm.toggle();
                  return null;
                },
              ),
              _SeekIntent: CallbackAction<_SeekIntent>(
                onInvoke: (intent) {
                  vm.seekBy(intent.seconds);
                  return null;
                },
              ),
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (engine is MediaKitEngine)
                  Video(
                    controller: engine.controller,
                    controls: NoVideoControls,
                  )
                else
                  const ColoredBox(color: Colors.black),
                if (viewState.loading || (state.buffering && problem == null))
                  const Center(child: CircularProgressIndicator()),
                if (viewState.needsMedia || problem != null)
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 650),
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: panel,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.video_library_outlined,
                            color: accent,
                            size: 36,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewState.needsMedia ? '为这一集选择视频' : '播放暂时未完成',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            problem ?? '选择数据源中的对应集数，或手动设置本集 HTTPS 视频地址。',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: muted),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              if (!widget.session.isDemo &&
                                  viewState.episode != null)
                                TvButton(
                                  label: '选择数据源',
                                  icon: Icons.dns_outlined,
                                  onPressed: () async {
                                    final selected = await context.push<bool>(
                                      '/sources/select/${widget.session.subjectId}/${viewState.episode!.id}',
                                    );
                                    if (selected == true && mounted) {
                                      await vm.retry();
                                    }
                                  },
                                ),
                              if (!widget.session.isDemo &&
                                  viewState.episode != null)
                                TvButton(
                                  label: '设置视频地址',
                                  icon: Icons.link,
                                  primary: true,
                                  autofocus: true,
                                  onPressed: () => showMediaDialog(
                                    context,
                                    onSave: vm.bindAndPlay,
                                  ),
                                ),
                              if (problem != null)
                                TvButton(
                                  label: '重试',
                                  icon: Icons.refresh,
                                  onPressed: vm.retry,
                                ),
                              TvButton(
                                label: '返回',
                                icon: Icons.arrow_back,
                                onPressed: _exit,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!viewState.needsMedia && problem == null)
                  SafeArea(
                    child: Column(
                      children: [
                        if (_controls)
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black87, Colors.transparent],
                              ),
                            ),
                            child: Row(
                              children: [
                                TvButton(
                                  label: '返回',
                                  icon: Icons.arrow_back,
                                  onPressed: _exit,
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.session.isDemo
                                            ? '播放器测试 · Flutter 示例视频'
                                            : viewState.anime?.title ??
                                                  '正在准备播放',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        widget.session.isDemo
                                            ? '测试不会保存观看记录'
                                            : viewState.episode?.title ?? '',
                                        style: const TextStyle(
                                          color: muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        if (_controls)
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 18),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black87],
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(formatTime(state.position)),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: state.duration.inMilliseconds > 0
                                            ? (state.position.inMilliseconds /
                                                      state
                                                          .duration
                                                          .inMilliseconds)
                                                  .clamp(0.0, 1.0)
                                            : 0,
                                        minHeight: 4,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(formatTime(state.duration)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    TvButton(
                                      label: '后退 10 秒',
                                      icon: Icons.replay_10,
                                      onPressed: () => vm.seekBy(-10),
                                    ),
                                    TvButton(
                                      label: state.playing ? '暂停' : '播放',
                                      autofocus: true,
                                      primary: true,
                                      icon: state.playing
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      onPressed: vm.toggle,
                                    ),
                                    TvButton(
                                      label: '前进 10 秒',
                                      icon: Icons.forward_10,
                                      onPressed: () => vm.seekBy(10),
                                    ),
                                    TvButton(
                                      label: '${viewState.rate}×',
                                      icon: Icons.speed,
                                      onPressed: vm.cycleRate,
                                    ),
                                    if (viewState.nextEpisode != null)
                                      TvButton(
                                        label: '下一集',
                                        icon: Icons.skip_next,
                                        onPressed: vm.playNext,
                                      ),
                                    TvButton(
                                      label: '隐藏控制',
                                      icon: Icons.visibility_off_outlined,
                                      onPressed: () =>
                                          setState(() => _controls = false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        if (!_controls)
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: TvButton(
                              label: '显示控制',
                              icon: Icons.tune,
                              autofocus: true,
                              onPressed: () => setState(() => _controls = true),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TogglePlaybackIntent extends Intent {
  const _TogglePlaybackIntent();
}

class _SeekIntent extends Intent {
  const _SeekIntent(this.seconds);
  final int seconds;
}
