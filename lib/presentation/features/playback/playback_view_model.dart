import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/models.dart';
import '../../../domain/repositories.dart';
import '../../../domain/danmaku.dart';
import '../../../domain/use_cases/prepare_playback.dart';
import '../../core/error_message.dart';

typedef PlaybackState = ({
  Anime? anime,
  Episode? episode,
  List<Episode> episodes,
  PlaybackSnapshot snapshot,
  bool loading,
  bool needsMedia,
  String? error,
  double rate,
  Episode? nextEpisode,
  DanmakuResult danmaku,
  DanmakuOptions danmakuOptions,
  bool danmakuLoading,
  int seekRevision,
});

class PlaybackViewModel extends Notifier<PlaybackState> {
  void _publish() {
    if (ref.mounted) state = _snapshotState;
  }

  PlaybackViewModel(PlaybackSession session)
    : subjectId = session.subjectId,
      episodeId = session.episodeId,
      isDemo = session.isDemo;
  late final PlaybackEngine engine;
  late final Talker _talker;
  late final LibraryRepository _library;
  late final CatalogRepository _catalog;
  late final SettingsRepository _settings;
  DanmakuRepository? _danmakuRepository;
  Future<void>? _initialization;
  final _sourceResolutionCancelled = Completer<void>();
  @override
  PlaybackState build() {
    _talker = ref.read(talkerProvider);
    engine = ref.read(playbackEngineFactoryProvider)();
    _library = ref.read(libraryRepositoryProvider);
    _catalog = ref.read(catalogRepositoryProvider);
    _settings = ref.read(settingsRepositoryProvider);
    _danmakuRepository = ref.read(danmakuRepositoryProvider);
    _subscription = engine.snapshots.listen(_onSnapshot);
    ref.onDispose(() {
      unawaited(close());
    });
    unawaited(
      Future.microtask(() {
        if (ref.mounted) return initialize();
      }),
    );
    return _snapshotState;
  }

  final int subjectId;
  final int episodeId;
  final bool isDemo;
  late final StreamSubscription<PlaybackSnapshot> _subscription;
  Anime? _anime;
  Episode? _episode;
  List<Episode> _episodes = const [];
  PlaybackSnapshot _snapshot = const PlaybackSnapshot();
  bool _loading = true;
  bool _needsMedia = false;
  String? _error;
  double _rate = 1;
  bool _ready = false;
  bool _closing = false;
  Future<void>? _closeFuture;
  bool _changing = false;
  bool _completedHandled = false;
  Future<void> _writes = Future.value();
  DateTime _lastSaved = DateTime.fromMillisecondsSinceEpoch(0);
  DanmakuResult _danmaku = const DanmakuResult();
  DanmakuOptions _danmakuOptions = const DanmakuOptions();
  bool _danmakuLoading = false;
  bool _danmakuOptionsLoaded = false;
  int _danmakuGeneration = 0;
  int _seekRevision = 0;
  Completer<void>? _danmakuCancelled;
  Future<void> _danmakuWrites = Future.value();

  void _cancelDanmaku() {
    _danmakuGeneration++;
    if (_danmakuCancelled case final cancelled? when !cancelled.isCompleted) {
      cancelled.complete();
    }
    _danmakuLoading = false;
  }

  Future<void> loadDanmaku({
    DanmakuMatch? selected,
    bool rematch = false,
  }) async {
    final repository = _danmakuRepository;
    final anime = _anime;
    final episode = _episode;
    if (isDemo ||
        _closing ||
        repository == null ||
        anime == null ||
        episode == null) {
      return;
    }
    _cancelDanmaku();
    final generation = _danmakuGeneration;
    final cancelled = _danmakuCancelled = Completer<void>();
    bool active() =>
        !_closing && ref.mounted && generation == _danmakuGeneration;
    _danmakuLoading = true;
    _danmaku = const DanmakuResult(message: '正在匹配弹幕…');
    _publish();
    try {
      if (!_danmakuOptionsLoaded) {
        final options = await repository.getOptions();
        if (!active()) return;
        _danmakuOptions = options;
        _danmakuOptionsLoaded = true;
      }
      if (!_danmakuOptions.enabled) {
        _danmaku = const DanmakuResult(message: '弹幕已关闭');
        return;
      }
      final result = await repository.load(
        anime,
        episode,
        selected: selected,
        rematch: rematch,
        cancelled: cancelled.future,
      );
      if (!active()) return;
      _danmaku = result;
      _talker.info('弹幕 · 章节 ${episode.id} · ${result.comments.length} 条');
    } catch (error, stack) {
      if (!active()) return;
      logFailure(_talker, '加载弹幕', error, stack);
      _danmaku = DanmakuResult(
        message: error is DanmakuException ? error.message : '弹幕加载失败，可在弹幕设置中重试',
      );
    } finally {
      if (active()) {
        _danmakuLoading = false;
        _publish();
      }
    }
  }

  Future<void> updateDanmakuOptions(DanmakuOptions options) async {
    final wasEnabled = _danmakuOptions.enabled;
    _danmakuOptions = options;
    _danmakuOptionsLoaded = true;
    if (!options.enabled) {
      _cancelDanmaku();
      _danmaku = const DanmakuResult(message: '弹幕已关闭');
    }
    _publish();
    // Serialize preferences writes so a slower old value cannot win.
    _danmakuWrites = _danmakuWrites
        .then((_) async {
          await _danmakuRepository?.saveOptions(options);
        })
        .catchError((Object error, StackTrace stack) {
          logFailure(_talker, '保存弹幕设置', error, stack);
        });
    if (!wasEnabled && options.enabled) unawaited(loadDanmaku());
    await _danmakuWrites;
  }

  Episode? get _nextEpisode {
    if (_episode == null) return null;
    final main = _episodes.where((e) => e.type == _episode!.type).toList();
    final index = main.indexWhere((e) => e.id == _episode!.id);
    return index >= 0 && index + 1 < main.length ? main[index + 1] : null;
  }

  Future<void> initialize() => _initialization ??= _initialize();
  Future<void> _initialize() async {
    if (_closing) return;
    try {
      if (isDemo) {
        await engine.open(
          PlayableMedia(
            Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
          ),
        );
        if (_closing) return;
        _ready = true;
      } else {
        final values = await Future.wait<Object>([
          _catalog.getAnime(subjectId),
          _catalog.getEpisodes(subjectId),
        ]);
        if (_closing) return;
        _anime = values[0] as Anime;
        _episodes = List.unmodifiable(values[1] as List<Episode>);
        _episode = _episodes.where((e) => e.id == episodeId).firstOrNull;
        if (_episode == null) throw const FormatException('该章节不属于当前番剧');
        await _openEpisode();
      }
    } catch (e, stack) {
      logFailure(_talker, '初始化播放器', e, stack);
      _error = errorMessage(e);
    } finally {
      _loading = false;
      _publish();
    }
  }

  Future<void> _openEpisode() async {
    _cancelDanmaku();
    _danmaku = const DanmakuResult();
    _seekRevision++;
    _ready = false;
    _needsMedia = false;
    _error = null;
    _completedHandled = false;
    _snapshot = const PlaybackSnapshot();
    _publish();
    try {
      var prepared = await PreparePlayback(_library)(_episode!);
      if (prepared.media.binding != null) {
        final refreshed =
            await RefreshMediaBinding(
              _library,
              ref.read(sourceRepositoryProvider),
            )(
              _episode!.id,
              prepared.media,
              cancelled: _sourceResolutionCancelled.future,
            );
        prepared = PreparedPlayback(refreshed, prepared.start);
      }
      if (_closing) return;
      await engine.open(prepared.media, start: prepared.start);
      _talker.info('播放章节 ${_episode!.id} · 从 ${prepared.start.inSeconds}s 开始');
      if (_closing) return;
      _ready = true;
      _snapshot = engine.snapshot;
      unawaited(loadDanmaku());
    } on MissingMediaException {
      _needsMedia = true;
    }
    _publish();
  }

  Future<void> bindAndPlay(String address) async {
    if (_changing || _episode == null) return;
    final media = parseMediaAddress(address);
    _changing = true;
    try {
      await _library.bindMedia(_episode!.id, media);
      await _openEpisode();
    } finally {
      _changing = false;
    }
  }

  Future<void> retry() async {
    if (_changing || _closing) return;
    _changing = true;
    _loading = true;
    _error = null;
    _publish();
    try {
      if (_episode == null) {
        await _initialize();
      } else {
        await _openEpisode();
      }
    } catch (e, stack) {
      logFailure(_talker, '重新打开视频', e, stack);
      _error = errorMessage(e);
    } finally {
      _loading = false;
      _changing = false;
      _publish();
    }
  }

  void _onSnapshot(PlaybackSnapshot value) {
    if (_closing) return;
    if (value.error != null && value.error != _snapshot.error) {
      _talker.warning('播放器报告错误 · 章节 ${_episode?.id ?? episodeId}');
    }
    _snapshot = value;
    _publish();
    if (!_ready) return;
    if (DateTime.now().difference(_lastSaved) >= const Duration(seconds: 5)) {
      unawaited(save());
    }
    if (value.completed && !_completedHandled) {
      _completedHandled = true;
      unawaited(_onCompleted());
    }
  }

  Future<void> _onCompleted() async {
    await save();
    try {
      if (!_closing && !isDemo && await _settings.getAutoPlay()) {
        await playNext();
      }
    } catch (error, stack) {
      logFailure(_talker, '自动播放下一集', error, stack);
      _error = '自动播放未完成，请手动选择下一集';
      _publish();
    }
  }

  Future<void> playNext() async {
    final next = _nextEpisode;
    if (next == null || _changing || _closing) return;
    _changing = true;
    try {
      await save();
      await engine.pause();
      _episode = next;
      await _openEpisode();
    } catch (e, stack) {
      logFailure(_talker, '切换下一集', e, stack);
      _error = errorMessage(e);
      _publish();
    } finally {
      _changing = false;
    }
  }

  Future<void> toggle() => _command(() async {
    if (_snapshot.playing) {
      await engine.pause();
      await save();
    } else {
      await engine.play();
    }
  });
  Future<void> seekBy(int seconds) => _command(() async {
    final end = _snapshot.duration.inMilliseconds;
    if (end <= 0) return;
    final ms = (_snapshot.position.inMilliseconds + seconds * 1000).clamp(
      0,
      end,
    );
    await engine.seek(Duration(milliseconds: ms));
    _seekRevision++;
    _publish();
  });
  Future<void> cycleRate() => _command(() async {
    const rates = [1.0, 1.25, 1.5, 2.0];
    final next = rates[(rates.indexOf(_rate) + 1) % rates.length];
    await engine.setRate(next);
    _rate = next;
    _publish();
  });
  Future<void> _command(Future<void> Function() command) async {
    if (!_ready || _closing) return;
    try {
      await command();
    } catch (error, stack) {
      logFailure(_talker, '播放器操作', error, stack);
      _error = '播放操作未完成，请重试';
      _publish();
    }
  }

  Future<void> save() {
    if (isDemo ||
        !_ready ||
        _anime == null ||
        _episode == null ||
        _snapshot.duration <= Duration.zero) {
      return Future.value();
    }
    _lastSaved = DateTime.now();
    final progress = WatchProgress(
      anime: _anime!,
      episode: _episode!,
      position: _snapshot.position,
      duration: _snapshot.duration,
      updatedAt: _lastSaved,
    );
    // Serialize writes so a slower earlier save cannot overwrite a later position.
    _writes = _writes.then((_) => _library.saveProgress(progress)).catchError((
      Object error,
      StackTrace stack,
    ) {
      logFailure(_talker, '保存观看进度', error, stack);
      _error = '观看进度保存失败';
      _publish();
    });
    return _writes;
  }

  Future<void> suspend() async {
    if (_closing) return;
    await _command(engine.pause);
    await save();
  }

  Future<void> close() => _closeFuture ??= _close();
  Future<void> _close() async {
    _closing = true;
    _cancelDanmaku();
    if (!_sourceResolutionCancelled.isCompleted) {
      _sourceResolutionCancelled.complete();
    }
    await _subscription.cancel();
    await save();
    await _danmakuWrites;
    await engine.dispose();
  }

  PlaybackState get _snapshotState => (
    anime: _anime,
    episode: _episode,
    episodes: _episodes,
    snapshot: _snapshot,
    loading: _loading,
    needsMedia: _needsMedia,
    error: _error,
    rate: _rate,
    nextEpisode: _nextEpisode,
    danmaku: _danmaku,
    danmakuOptions: _danmakuOptions,
    danmakuLoading: _danmakuLoading,
    seekRevision: _seekRevision,
  );
}

// Include the route identity so opening the same episode twice never shares a
// native player. GoRouter's page key is stable across rebuilds of one route.
typedef PlaybackSession = ({
  int subjectId,
  int episodeId,
  bool isDemo,
  Object routeKey,
});
final playbackViewModelProvider = NotifierProvider.autoDispose
    .family<PlaybackViewModel, PlaybackState, PlaybackSession>(
      PlaybackViewModel.new,
      name: 'playback',
    );
