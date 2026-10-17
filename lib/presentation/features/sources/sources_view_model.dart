import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/video_source.dart';
import '../../core/error_message.dart';

typedef SourcesState = ({
  List<VideoSource> sources,
  bool loading,
  bool busy,
  String? error,
  String? message,
});

class SourcesViewModel extends Notifier<SourcesState> {
  @override
  SourcesState build() {
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load();
      }),
    );
    return (
      sources: const [],
      loading: true,
      busy: false,
      error: null,
      message: null,
    );
  }

  Future<void> load() async {
    try {
      final sources = await ref.read(sourceRepositoryProvider).load();
      if (ref.mounted) {
        state = (
          sources: sources,
          loading: false,
          busy: false,
          error: null,
          message: null,
        );
      }
    } catch (error, stack) {
      if (!ref.mounted) return;
      logFailure(ref.read(talkerProvider), '加载数据源配置', error, stack);
      state = (
        sources: const [],
        loading: false,
        busy: false,
        error: '数据源配置读取失败，请重试',
        message: null,
      );
    }
  }

  Future<void> save(VideoSource source) => _command(
    () => ref.read(sourceRepositoryProvider).save(source),
    reload: true,
  );
  Future<void> remove(VideoSource source) => _command(
    () => ref.read(sourceRepositoryProvider).remove(source.id),
    reload: true,
  );
  Future<void> check(VideoSource source) => _command(
    () => ref.read(sourceRepositoryProvider).check(source),
    message: source.factoryId == 'maccms'
        ? '连接成功，接口返回有效 JSON 数据'
        : '数据源搜索规则验证成功',
  );
  Future<void> importSubscription(String url) => _command(
    () async {
      await ref.read(sourceRepositoryProvider).importSubscription(url);
    },
    reload: true,
    message: 'Animeko 在线数据源订阅已更新',
  );

  Future<void> _command(
    Future<void> Function() action, {
    bool reload = false,
    String? message,
  }) async {
    if (state.busy || state.loading) return;
    state = (
      sources: state.sources,
      loading: false,
      busy: true,
      error: null,
      message: null,
    );
    try {
      await action();
      if (!ref.mounted) return;
      final sources = reload
          ? await ref.read(sourceRepositoryProvider).load()
          : state.sources;
      if (ref.mounted) {
        state = (
          sources: sources,
          loading: false,
          busy: false,
          error: null,
          message: message,
        );
      }
    } catch (error, stack) {
      if (!ref.mounted) return;
      logFailure(ref.read(talkerProvider), '数据源操作失败', error, stack);
      state = (
        sources: state.sources,
        loading: false,
        busy: false,
        error: errorMessage(error),
        message: null,
      );
      rethrow;
    }
  }
}

final sourcesViewModelProvider =
    NotifierProvider.autoDispose<SourcesViewModel, SourcesState>(
      SourcesViewModel.new,
      name: 'sources',
    );
