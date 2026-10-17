import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/models.dart';
import '../../../domain/video_source.dart';
import '../../core/error_message.dart';

part 'source_picker_view_model.freezed.dart';

typedef SourceTarget = ({int subjectId, int episodeId});

@freezed
abstract class SourcePickerState with _$SourcePickerState {
  const factory SourcePickerState({
    Anime? anime,
    Episode? episode,
    @Default(<VideoSource>[]) List<VideoSource> sources,
    VideoSource? source,
    @Default('') String query,
    @Default(<SourceTitle>[]) List<SourceTitle> results,
    SourceTitle? title,
    @Default(<SourceLine>[]) List<SourceLine> lines,
    @Default(true) bool loading,
    @Default(false) bool loadingMore,
    @Default(false) bool saving,
    @Default(0) int page,
    @Default(0) int pageCount,
    @Default(0) int total,
    String? error,
  }) = _SourcePickerState;
}

class SourcePickerViewModel extends Notifier<SourcePickerState> {
  SourcePickerViewModel(this.target);
  final SourceTarget target;
  int _generation = 0;
  final _cancelled = Completer<void>();
  @override
  SourcePickerState build() {
    ref.onDispose(() {
      if (!_cancelled.isCompleted) _cancelled.complete();
    });
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load();
      }),
    );
    return const SourcePickerState();
  }

  Future<void> load() async {
    final generation = ++_generation;
    state = state.copyWith(
      loading: true,
      error: null,
      source: null,
      title: null,
      lines: const [],
      results: const [],
      page: 0,
      pageCount: 0,
      total: 0,
    );
    try {
      final catalog = ref.read(catalogRepositoryProvider);
      final values = await Future.wait<Object>([
        catalog.getAnime(target.subjectId),
        catalog.getEpisodes(target.subjectId),
        ref.read(sourceRepositoryProvider).load(),
      ]);
      if (!ref.mounted || generation != _generation) return;
      final anime = values[0] as Anime;
      final episode = (values[1] as List<Episode>)
          .where(
            (episode) =>
                episode.id == target.episodeId &&
                episode.subjectId == target.subjectId,
          )
          .firstOrNull;
      if (episode == null) throw const FormatException('该章节不属于当前番剧');
      final sources = List<VideoSource>.unmodifiable(
        (values[2] as List<VideoSource>).where((source) => source.enabled),
      );
      state = state.copyWith(
        anime: anime,
        episode: episode,
        sources: sources,
        source:
            sources
                .where((source) => source.factoryId == 'json-api')
                .firstOrNull ??
            sources.firstOrNull,
        query: anime.title,
        loading: false,
        error: null,
      );
      if (sources.isNotEmpty) await search(anime.title);
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(ref.read(talkerProvider), '准备选择视频源', error, stack);
      state = state.copyWith(loading: false, error: errorMessage(error));
    }
  }

  Future<void> chooseSource(VideoSource source) async {
    if (state.saving || !state.sources.contains(source)) return;
    state = state.copyWith(source: source);
    await search(state.query);
  }

  Future<void> search(String query) async {
    final source = state.source;
    if (source == null || state.saving) return;
    final generation = ++_generation;
    state = state.copyWith(
      query: query.trim(),
      results: const [],
      lines: const [],
      title: null,
      loading: true,
      loadingMore: false,
      page: 0,
      pageCount: 0,
      total: 0,
      error: null,
    );
    try {
      final page = await ref
          .read(sourceRepositoryProvider)
          .search(source, state.query);
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        results: page.items,
        page: page.page,
        pageCount: page.pageCount,
        total: page.total,
        loading: false,
      );
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(ref.read(talkerProvider), '搜索视频源', error, stack);
      state = state.copyWith(loading: false, error: errorMessage(error));
    }
  }

  Future<void> loadMore() async {
    if (state.loading ||
        state.loadingMore ||
        state.page >= state.pageCount ||
        state.source == null) {
      return;
    }
    final generation = _generation;
    state = state.copyWith(loadingMore: true, error: null);
    try {
      final page = await ref
          .read(sourceRepositoryProvider)
          .search(state.source!, state.query, page: state.page + 1);
      if (!ref.mounted || generation != _generation) return;
      final seen = state.results.map((item) => item.id).toSet();
      state = state.copyWith(
        results: List.unmodifiable([
          ...state.results,
          ...page.items.where((item) => seen.add(item.id)),
        ]),
        page: page.page,
        pageCount: page.items.isEmpty ? page.page : page.pageCount,
        total: page.total,
        loadingMore: false,
      );
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(ref.read(talkerProvider), '视频源分页', error, stack);
      state = state.copyWith(loadingMore: false, error: errorMessage(error));
    }
  }

  Future<void> chooseTitle(SourceTitle title) async {
    if (state.source == null || state.saving) return;
    final generation = ++_generation;
    state = state.copyWith(
      title: title,
      lines: const [],
      loading: true,
      loadingMore: false,
      error: null,
    );
    try {
      final lines = await ref
          .read(sourceRepositoryProvider)
          .lines(state.source!, title.id);
      if (ref.mounted && generation == _generation) {
        state = state.copyWith(lines: lines, loading: false);
      }
    } catch (error, stack) {
      if (!ref.mounted || generation != _generation) return;
      logFailure(ref.read(talkerProvider), '读取视频线路', error, stack);
      state = state.copyWith(loading: false, error: errorMessage(error));
    }
  }

  Future<bool> bind(SourceEpisode episode) async {
    if (state.saving ||
        state.episode == null ||
        state.title == null ||
        !state.lines.any((line) => line.episodes.contains(episode)) ||
        !episode.selectable) {
      return false;
    }
    state = state.copyWith(saving: true, error: null);
    final talker = ref.read(talkerProvider);
    try {
      final media = await ref
          .read(sourceRepositoryProvider)
          .resolve(state.source!, episode, cancelled: _cancelled.future);
      if (!ref.mounted) return false;
      await ref
          .read(libraryRepositoryProvider)
          .bindMedia(
            target.episodeId,
            PlayableMedia(
              media.uri,
              headers: media.headers,
              binding: state.source!.factoryId == 'maccms'
                  ? null
                  : MediaSourceBinding(
                      sourceId: state.source!.id,
                      label: episode.label,
                      address: episode.address,
                      needsResolution: episode.needsResolution,
                      context: episode.context,
                    ),
            ),
          );
      talker.info('已绑定视频资源到章节 ${target.episodeId}');
      if (ref.mounted) state = state.copyWith(saving: false);
      return true;
    } catch (error, stack) {
      if (ref.mounted) {
        logFailure(ref.read(talkerProvider), '绑定视频资源', error, stack);
        state = state.copyWith(saving: false, error: errorMessage(error));
      }
      return false;
    }
  }
}

final sourcePickerViewModelProvider = NotifierProvider.autoDispose
    .family<SourcePickerViewModel, SourcePickerState, SourceTarget>(
      SourcePickerViewModel.new,
      name: 'sourcePicker',
    );
