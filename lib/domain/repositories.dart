import 'models.dart';
import 'anime_filter.dart';

abstract interface class CatalogRepository {
  Future<DiscoveryFeed> discover();
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  });
  Future<Anime> getAnime(int id);
  Future<List<Episode>> getEpisodes(int subjectId);
}

abstract interface class LibraryRepository {
  Stream<List<Anime>> watchFavorites();
  Stream<List<WatchProgress>> watchHistory();
  Future<bool> isFavorite(int subjectId);
  Future<void> setFavorite(Anime anime, bool value);
  Future<WatchProgress?> getProgress(int episodeId);
  Future<void> saveProgress(WatchProgress progress);
  Future<void> deleteProgress(int episodeId);
  Future<PlayableMedia?> getMedia(int episodeId);
  Future<void> bindMedia(int episodeId, PlayableMedia media);
}

abstract interface class PlaybackEngine {
  PlaybackSnapshot get snapshot;
  Stream<PlaybackSnapshot> get snapshots;
  Future<void> open(PlayableMedia media, {Duration start = Duration.zero});
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> setRate(double rate);
  Future<void> dispose();
}

abstract interface class SettingsRepository {
  Future<bool> getAutoPlay();
  Future<void> setAutoPlay(bool value);
}
