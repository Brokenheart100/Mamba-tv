import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/models.dart';
import '../../../domain/repositories.dart';
import '../../../domain/use_cases/prepare_playback.dart';
import '../../core/error_message.dart';

typedef DetailState = ({
  Anime? anime,
  List<Episode> episodes,
  bool loading,
  bool favorite,
  bool saving,
  String? error,
});

class DetailViewModel extends Notifier<DetailState> {
  bool get _disposed => !ref.mounted;
  void _publish() {
    if (ref.mounted) state = _snapshotState;
  }

  DetailViewModel(this.subjectId);
  late final CatalogRepository _catalog;
  late final LibraryRepository _library;
  @override
  DetailState build() {
    _catalog = ref.read(catalogRepositoryProvider);
    _library = ref.read(libraryRepositoryProvider);
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return load();
      }),
    );
    return _snapshotState;
  }

  final int subjectId;
  Anime? _anime;
  List<Episode> _episodes = const [];
  bool _loading = true;
  bool _favorite = false;
  bool _saving = false;
  String? _error;
  Future<void> load() async {
    _loading = true;
    _error = null;
    _publish();
    try {
      final values = await Future.wait<Object>([
        _catalog.getAnime(subjectId),
        _catalog.getEpisodes(subjectId),
        _library.isFavorite(subjectId),
      ]);
      if (_disposed) return;
      _anime = values[0] as Anime;
      _episodes = List.unmodifiable(values[1] as List<Episode>);
      _favorite = values[2] as bool;
    } catch (e, stack) {
      if (ref.mounted) logFailure(ref.read(talkerProvider), '加载番剧详情', e, stack);
      _error = errorMessage(e);
    } finally {
      _loading = false;
      _publish();
    }
  }

  Future<void> toggleFavorite() async {
    if (_anime == null || _saving) return;
    _saving = true;
    _error = null;
    _publish();
    try {
      await _library.setFavorite(_anime!, !_favorite);
      _favorite = !_favorite;
    } catch (e, stack) {
      if (ref.mounted) logFailure(ref.read(talkerProvider), '更新追番', e, stack);
      _error = errorMessage(e);
    } finally {
      _saving = false;
      _publish();
    }
  }

  Future<void> bindMedia(Episode episode, String address) =>
      _library.bindMedia(episode.id, parseMediaAddress(address));
  Future<String> mediaAddress(Episode episode) async =>
      (await _library.getMedia(episode.id))?.uri.toString() ?? '';

  DetailState get _snapshotState => (
    anime: _anime,
    episodes: _episodes,
    loading: _loading,
    favorite: _favorite,
    saving: _saving,
    error: _error,
  );
}

final detailViewModelProvider = NotifierProvider.autoDispose
    .family<DetailViewModel, DetailState, int>(DetailViewModel.new);
