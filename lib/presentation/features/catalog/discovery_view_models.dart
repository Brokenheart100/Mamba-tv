import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/logging.dart';
import '../../../app/providers.dart';
import '../../../domain/bangumi_discovery.dart';
import '../../../domain/models.dart';
import '../../core/error_message.dart';

typedef CalendarState = ({
  List<BroadcastDay> days,
  int weekday,
  bool loading,
  String? error,
});

class CalendarViewModel extends Notifier<CalendarState> {
  int _generation = 0;
  @override
  CalendarState build() {
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load();
      }),
    );
    return (
      days: const [],
      weekday: DateTime.now().weekday,
      loading: true,
      error: null,
    );
  }

  void selectDay(int day) {
    if (day >= 1 && day <= 7) {
      state = (
        days: state.days,
        weekday: day,
        loading: state.loading,
        error: state.error,
      );
    }
  }

  Future<void> load() async {
    final generation = ++_generation;
    state = (
      days: state.days,
      weekday: state.weekday,
      loading: true,
      error: null,
    );
    try {
      final repository = ref.read(bangumiDiscoveryRepositoryProvider);
      if (repository == null) {
        throw StateError('Bangumi discovery is not configured');
      }
      final days = await repository.calendar();
      if (!ref.mounted || generation != _generation) return;
      state = (
        days: List.unmodifiable(days),
        weekday: state.weekday,
        loading: false,
        error: null,
      );
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(ref.read(talkerProvider), '加载新番周历', error, stack);
      state = (
        days: state.days,
        weekday: state.weekday,
        loading: false,
        error: errorMessage(error),
      );
    }
  }
}

typedef BrowseState = ({
  BrowseQuery query,
  List<Anime> items,
  int total,
  bool hasMore,
  bool loading,
  bool loadingMore,
  String? error,
});

class BrowseViewModel extends Notifier<BrowseState> {
  int _generation = 0;
  int _offset = 0;
  @override
  BrowseState build() {
    final now = DateTime.now();
    final query = BrowseQuery(
      year: now.year,
      quarter: (now.month - 1) ~/ 3 + 1,
    );
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load(query);
      }),
    );
    return (
      query: query,
      items: const [],
      total: 0,
      hasMore: false,
      loading: true,
      loadingMore: false,
      error: null,
    );
  }

  Future<void> changeMode(BrowseMode mode) {
    final now = DateTime.now();
    return load(
      state.query.copyWith(
        mode: mode,
        year: mode == BrowseMode.ranking ? 0 : now.year,
      ),
    );
  }

  Future<void> load(BrowseQuery query) async {
    final generation = ++_generation;
    _offset = 0;
    state = (
      query: query,
      items: const [],
      total: 0,
      hasMore: false,
      loading: true,
      loadingMore: false,
      error: null,
    );
    await _fetch(generation, more: false);
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    state = (
      query: state.query,
      items: state.items,
      total: state.total,
      hasMore: state.hasMore,
      loading: false,
      loadingMore: true,
      error: null,
    );
    await _fetch(_generation, more: true);
  }

  Future<void> retry() => state.items.isEmpty ? load(state.query) : loadMore();

  Future<void> _fetch(int generation, {required bool more}) async {
    try {
      final repository = ref.read(bangumiDiscoveryRepositoryProvider);
      if (repository == null) {
        throw StateError('Bangumi discovery is not configured');
      }
      final page = await repository.browse(state.query, offset: _offset);
      if (!ref.mounted || generation != _generation) return;
      _offset += page.items.length;
      final items = <int, Anime>{
        for (final item in [...state.items, ...page.items]) item.id: item,
      };
      state = (
        query: state.query,
        items: List.unmodifiable(items.values),
        total: page.total,
        hasMore: page.items.isNotEmpty && _offset < page.total,
        loading: false,
        loadingMore: false,
        error: null,
      );
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(
        ref.read(talkerProvider),
        more ? '番剧榜单分页' : '加载季度新番',
        error,
        stack,
      );
      state = (
        query: state.query,
        items: state.items,
        total: state.total,
        hasMore: state.hasMore,
        loading: false,
        loadingMore: false,
        error: errorMessage(error),
      );
    }
  }
}

final calendarViewModelProvider =
    NotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
      CalendarViewModel.new,
      name: 'broadcast-calendar',
    );
final browseViewModelProvider =
    NotifierProvider.autoDispose<BrowseViewModel, BrowseState>(
      BrowseViewModel.new,
      name: 'season-ranking',
    );
