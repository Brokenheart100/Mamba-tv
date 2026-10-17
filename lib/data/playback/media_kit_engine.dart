import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';

class MediaKitEngine implements PlaybackEngine {
  MediaKitEngine({bool androidEmulator = false}) {
    // Recent emulator EGL images reject mpv's GL context. Use MediaCodec Surface
    // output only on emulators; physical devices retain full default rendering.
    controller = VideoController(
      player,
      configuration: androidEmulator
          ? const VideoControllerConfiguration(
              vo: 'mediacodec_embed',
              hwdec: 'mediacodec',
            )
          : const VideoControllerConfiguration(),
    );
    _subscriptions.addAll([
      player.stream.position.listen((_) => _emit()),
      player.stream.duration.listen((_) => _emit()),
      player.stream.playing.listen((_) => _emit()),
      player.stream.buffering.listen((_) => _emit()),
      player.stream.completed.listen((_) => _emit()),
      player.stream.error.listen((_) {
        _error = '视频播放失败，请检查地址是否过期或更换媒体文件';
        _emit();
      }),
    ]);
  }
  final Player player = Player();
  late final VideoController controller;
  final _events = StreamController<PlaybackSnapshot>.broadcast();
  final _subscriptions = <StreamSubscription<dynamic>>[];
  String? _error;
  bool _disposed = false;
  Future<void>? _disposeFuture;
  @override
  PlaybackSnapshot get snapshot => PlaybackSnapshot(
    position: player.state.position,
    duration: player.state.duration,
    playing: player.state.playing,
    buffering: player.state.buffering,
    completed: player.state.completed,
    error: _error,
  );
  @override
  Stream<PlaybackSnapshot> get snapshots => _events.stream;
  void _emit() {
    if (!_disposed) _events.add(snapshot);
  }

  @override
  Future<void> open(
    PlayableMedia media, {
    Duration start = Duration.zero,
  }) async {
    _error = null;
    await player.open(
      Media(media.uri.toString(), httpHeaders: media.headers, start: start),
    );
  }

  @override
  Future<void> play() => player.play();
  @override
  Future<void> pause() => player.pause();
  @override
  Future<void> seek(Duration position) => player.seek(position);
  @override
  Future<void> setRate(double rate) => player.setRate(rate);
  @override
  Future<void> dispose() => _disposeFuture ??= _dispose();
  Future<void> _dispose() async {
    _disposed = true;
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await player.dispose();
    await _events.close();
  }
}
