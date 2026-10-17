import 'dart:async';

import 'package:mamba_tv/domain/models.dart';
import 'package:mamba_tv/domain/anime_filter.dart';
import 'package:mamba_tv/domain/repositories.dart';
import 'package:mamba_tv/domain/video_source.dart';
import 'package:mamba_tv/domain/use_cases/prepare_playback.dart';

const testAnime = Anime(
  id: 1,
  title: '测试番剧',
  originalTitle: 'Test Anime',
  summary: '用于离线验证界面布局和遥控器操作的测试资料。',
  date: '2026-10-01',
  score: 8.5,
  episodeCount: 12,
  tags: ['测试', '动画'],
);
const testEpisode = Episode(id: 11, subjectId: 1, title: '第一集', sort: 1);
const nextEpisode = Episode(id: 12, subjectId: 1, title: '第二集', sort: 2);

class FakeSources implements SourceRepository {
  List<VideoSource> sources = [];
  @override
  Future<List<VideoSource>> load() async => List.unmodifiable(sources);
  @override
  Future<void> save(VideoSource source) async {
    sources = [...sources.where((item) => item.id != source.id), source];
  }

  @override
  Future<void> remove(String sourceId) async {
    sources.removeWhere((source) => source.id == sourceId);
  }

  @override
  Future<void> check(VideoSource source) async {}
  @override
  Future<int> importSubscription(String url) async => sources.length;
  @override
  Future<PlayableMedia> resolve(
    VideoSource source,
    SourceEpisode episode, {
    Future<void>? cancelled,
  }) async => parseMediaAddress(episode.address);
  @override
  Future<SourcePage> search(
    VideoSource source,
    String keyword, {
    int page = 1,
  }) async => const SourcePage(
    [SourceTitle(id: '7', title: '测试番剧资源')],
    page: 1,
    pageCount: 1,
    total: 1,
  );
  @override
  Future<List<SourceLine>> lines(VideoSource source, String titleId) async =>
      const [
        SourceLine('HLS', [
          SourceEpisode(label: '第1集', address: 'https://example.com/one.m3u8'),
          SourceEpisode(label: '第2集', address: 'https://example.com/two.mp4'),
        ]),
      ];
}

class FakeCatalog implements CatalogRepository {
  @override
  Future<DiscoveryFeed> discover() async =>
      const DiscoveryFeed(airing: [testAnime], popular: [testAnime]);
  @override
  Future<Anime> getAnime(int id) async => testAnime;
  @override
  Future<List<Episode>> getEpisodes(int subjectId) async => [
    testEpisode,
    nextEpisode,
  ];
  @override
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  }) async => const AnimePage([testAnime], 1);
}

class FakeSettings implements SettingsRepository {
  bool autoPlay = false;
  @override
  Future<bool> getAutoPlay() async => autoPlay;
  @override
  Future<void> setAutoPlay(bool value) async {
    autoPlay = value;
  }
}

class FakeLibrary implements LibraryRepository {
  final progress = <int, WatchProgress>{};
  final media = <int, PlayableMedia>{};
  final favorites = <int, Anime>{};
  final saved = <WatchProgress>[];
  final _favorites = StreamController<List<Anime>>.broadcast();
  final _history = StreamController<List<WatchProgress>>.broadcast();
  @override
  Stream<List<Anime>> watchFavorites() async* {
    yield favorites.values.toList();
    yield* _favorites.stream;
  }

  @override
  Stream<List<WatchProgress>> watchHistory() async* {
    yield progress.values.toList();
    yield* _history.stream;
  }

  @override
  Future<bool> isFavorite(int subjectId) async =>
      favorites.containsKey(subjectId);
  @override
  Future<void> setFavorite(Anime anime, bool value) async {
    if (value) {
      favorites[anime.id] = anime;
    } else {
      favorites.remove(anime.id);
    }
    _favorites.add(favorites.values.toList());
  }

  @override
  Future<WatchProgress?> getProgress(int episodeId) async =>
      progress[episodeId];
  @override
  Future<void> saveProgress(WatchProgress value) async {
    saved.add(value);
    progress[value.episode.id] = value;
    _history.add(progress.values.toList());
  }

  @override
  Future<void> deleteProgress(int episodeId) async {
    progress.remove(episodeId);
    _history.add(progress.values.toList());
  }

  @override
  Future<PlayableMedia?> getMedia(int episodeId) async => media[episodeId];
  @override
  Future<void> bindMedia(int episodeId, PlayableMedia value) async {
    media[episodeId] = value;
  }

  Future<void> close() async {
    await _favorites.close();
    await _history.close();
  }
}

class FakeEngine implements PlaybackEngine {
  final _stream = StreamController<PlaybackSnapshot>.broadcast(sync: true);
  final opened = <PlayableMedia>[];
  Duration start = Duration.zero;
  bool released = false;
  @override
  PlaybackSnapshot snapshot = const PlaybackSnapshot();
  @override
  Stream<PlaybackSnapshot> get snapshots => _stream.stream;
  void emit(PlaybackSnapshot value) {
    snapshot = value;
    _stream.add(value);
  }

  @override
  Future<void> open(
    PlayableMedia media, {
    Duration start = Duration.zero,
  }) async {
    opened.add(media);
    this.start = start;
    emit(
      PlaybackSnapshot(
        position: start,
        duration: const Duration(minutes: 24),
        playing: true,
      ),
    );
  }

  @override
  Future<void> pause() async => emit(
    PlaybackSnapshot(
      position: snapshot.position,
      duration: snapshot.duration,
      playing: false,
    ),
  );
  @override
  Future<void> play() async => emit(
    PlaybackSnapshot(
      position: snapshot.position,
      duration: snapshot.duration,
      playing: true,
    ),
  );
  @override
  Future<void> seek(Duration position) async => emit(
    PlaybackSnapshot(
      position: position,
      duration: snapshot.duration,
      playing: snapshot.playing,
    ),
  );
  @override
  Future<void> setRate(double rate) async {}
  @override
  Future<void> dispose() async {
    released = true;
    await _stream.close();
  }
}
