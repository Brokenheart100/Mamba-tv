import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/repositories.dart';

typedef SettingsState = ({bool autoPlay, bool busy, String? error});

class SettingsViewModel extends Notifier<SettingsState> {
  void _publish() {
    if (ref.mounted) state = _snapshotState;
  }

  late final SettingsRepository _repository;
  @override
  SettingsState build() {
    _repository = ref.read(settingsRepositoryProvider);
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load();
      }),
    );
    return _snapshotState;
  }

  bool _autoPlay = false;
  bool _busy = true;
  String? _error;
  Future<void> load() async {
    _busy = true;
    _publish();
    try {
      _autoPlay = await _repository.getAutoPlay();
    } catch (_) {
      _error = '设置读取失败';
    } finally {
      _busy = false;
      _publish();
    }
  }

  Future<void> toggleAutoPlay() async {
    if (_busy) return;
    _busy = true;
    _error = null;
    _publish();
    try {
      await _repository.setAutoPlay(!_autoPlay);
      _autoPlay = !_autoPlay;
    } catch (_) {
      _error = '设置保存失败';
    } finally {
      _busy = false;
      _publish();
    }
  }

  SettingsState get _snapshotState =>
      (autoPlay: _autoPlay, busy: _busy, error: _error);
}

final settingsViewModelProvider =
    NotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
      SettingsViewModel.new,
    );
