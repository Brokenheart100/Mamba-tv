import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models.dart';
import '../../../domain/repositories.dart';

typedef LibraryState = ({
  List<Anime> favorites,
  List<WatchProgress> history,
  bool favoritesReady,
  bool historyReady,
  String? error,
});

class LibraryViewModel extends Notifier<LibraryState> {
  void _publish() {
    if (ref.mounted) state = _snapshotState;
  }

  @override
  LibraryState build() {
    _repository = ref.read(libraryRepositoryProvider);
    ref.onDispose(() {
      for (final sub in _subscriptions) {
        unawaited(sub.cancel());
      }
    });
    unawaited(
      Future.microtask(() {
        if (ref.mounted) _subscribe();
      }),
    );
    return _snapshotState;
  }

  void _subscribe() {
    _subscriptions.add(
      _repository.watchFavorites().listen((value) {
        _favorites = List.unmodifiable(value);
        _favoritesReady = true;
        _publish();
      }, onError: _onError),
    );
    _subscriptions.add(
      _repository.watchHistory().listen((value) {
        _history = List.unmodifiable(value);
        _historyReady = true;
        _publish();
      }, onError: _onError),
    );
  }

  late final LibraryRepository _repository;
  final _subscriptions = <StreamSubscription<dynamic>>[];
  List<Anime> _favorites = const [];
  List<WatchProgress> _history = const [];
  bool _favoritesReady = false;
  bool _historyReady = false;
  String? _error;
  void _onError(Object error) {
    _error = '本地记录读取失败，请重新启动应用';
    _publish();
  }

  Future<void> removeHistory(int id) async {
    try {
      await _repository.deleteProgress(id);
    } catch (_) {
      _error = '未能删除记录，请重试';
      _publish();
    }
  }

  LibraryState get _snapshotState => (
    favorites: _favorites,
    history: _history,
    favoritesReady: _favoritesReady,
    historyReady: _historyReady,
    error: _error,
  );
}

final libraryViewModelProvider =
    NotifierProvider<LibraryViewModel, LibraryState>(LibraryViewModel.new);
