import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/models.dart';
import '../../../domain/anime_filter.dart';
import '../../../domain/repositories.dart';
import '../../core/error_message.dart';

typedef CatalogState = ({
  DiscoveryFeed? feed,
  List<Anime> results,
  String query,
  String? error,
  bool loading,
  bool loadingMore,
  int total,
  AnimeFilter? filter,
  bool hasMore,
});

class CatalogViewModel extends Notifier<CatalogState> {
  bool get _disposed => !ref.mounted;
  void _publish() {
    if (ref.mounted) state = _snapshotState;
  }

  CatalogViewModel({this.discoverOnStart = false, this.browseOnStart = false});
  final bool discoverOnStart;
  final bool browseOnStart;
  late final CatalogRepository _repository;
  @override
  CatalogState build() {
    _repository = ref.read(catalogRepositoryProvider);
    if (discoverOnStart || browseOnStart) {
      _loading = true;
      if (browseOnStart) _filter = const AnimeFilter();
      unawaited(
        Future.microtask(() {
          if (ref.mounted) {
            return browseOnStart ? applyFilter(_filter!) : load();
          }
        }),
      );
    }
    return _snapshotState;
  }

  DiscoveryFeed? _feed;
  List<Anime> _results = const [];
  String _query = '';
  String? _error;
  bool _loading = false;
  bool _loadingMore = false;
  int _total = 0;
  int _generation = 0;
  AnimeFilter? _filter;
  int _offset = 0;
  bool get _hasMore => _offset < _total;
  Future<void> load() async {
    final generation = ++_generation;
    _loading = true;
    _error = null;
    _publish();
    try {
      final value = await _repository.discover();
      if (generation != _generation || _disposed) return;
      _feed = value;
    } catch (e, stack) {
      if (ref.mounted) logFailure(ref.read(talkerProvider), '读取发现目录', e, stack);
      if (generation == _generation) _error = errorMessage(e);
    } finally {
      if (generation == _generation) {
        _loading = false;
        _publish();
      }
    }
  }

  Future<void> search(String keyword) => _search(keyword);

  Future<void> applyFilter(AnimeFilter filter) => _search('', filter: filter);

  Future<void> retry() => _search(_query, filter: _filter);

  Future<void> _search(String keyword, {AnimeFilter? filter}) async {
    final generation = ++_generation;
    _query = keyword.trim();
    _filter = filter;
    _loading = true;
    _loadingMore = false;
    _error = null;
    _results = const [];
    _total = 0;
    _offset = 0;
    _publish();
    try {
      final page = await _repository.search(_query, filter: _filter);
      if (generation != _generation || _disposed) return;
      _results = List.unmodifiable(page.items);
      _total = page.total;
      _offset = page.items.length;
    } catch (e, stack) {
      if (ref.mounted && generation == _generation) {
        logFailure(ref.read(talkerProvider), '查询番剧目录', e, stack);
      }
      if (generation == _generation) _error = errorMessage(e);
    } finally {
      if (generation == _generation) {
        _loading = false;
        _publish();
      }
    }
  }

  Future<void> loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;
    final generation = _generation;
    _loadingMore = true;
    _error = null;
    _publish();
    try {
      final page = await _repository.search(
        _query,
        offset: _offset,
        filter: _filter,
      );
      if (generation != _generation || _disposed) return;
      final seen = _results.map((anime) => anime.id).toSet();
      _results = List.unmodifiable([
        ..._results,
        ...page.items.where((anime) => seen.add(anime.id)),
      ]);
      _offset += page.items.length;
      _total = page.items.isEmpty ? _offset : page.total;
    } catch (e, stack) {
      if (ref.mounted && generation == _generation) {
        logFailure(ref.read(talkerProvider), '目录分页', e, stack);
      }
      if (generation == _generation) _error = errorMessage(e);
    } finally {
      if (generation == _generation) {
        _loadingMore = false;
        _publish();
      }
    }
  }

  DiscoveryFeed? get feed => _feed;
  CatalogState get _snapshotState => (
    feed: _feed,
    results: _results,
    query: _query,
    error: _error,
    loading: _loading,
    loadingMore: _loadingMore,
    total: _total,
    filter: _filter,
    hasMore: _hasMore,
  );
}

final homeViewModelProvider =
    NotifierProvider.autoDispose<CatalogViewModel, CatalogState>(
      () => CatalogViewModel(discoverOnStart: true),
      name: 'home',
    );
final searchViewModelProvider =
    NotifierProvider.autoDispose<CatalogViewModel, CatalogState>(
      CatalogViewModel.new,
      name: 'search',
    );

final categoryViewModelProvider =
    NotifierProvider.autoDispose<CatalogViewModel, CatalogState>(
      () => CatalogViewModel(browseOnStart: true),
      name: 'categories',
    );
