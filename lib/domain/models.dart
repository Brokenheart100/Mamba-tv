import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Anime with _$Anime {
  const factory Anime({
    required int id,
    required String title,
    @Default('') String originalTitle,
    @Default('') String image,
    @Default('') String summary,
    @Default('') String date,
    @Default(0) double score,
    @Default(0) int episodeCount,
    @Default(<String>[]) List<String> tags,
  }) = _Anime;
}

@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    required int id,
    required int subjectId,
    required String title,
    required double sort,
    @Default(0) int type,
  }) = _Episode;
}

@freezed
abstract class WatchProgress with _$WatchProgress {
  const factory WatchProgress({
    required Anime anime,
    required Episode episode,
    required Duration position,
    required Duration duration,
    required DateTime updatedAt,
  }) = _WatchProgress;
}

class DiscoveryFeed {
  const DiscoveryFeed({required this.airing, required this.popular});
  final List<Anime> airing;
  final List<Anime> popular;
}

class AnimePage {
  const AnimePage(this.items, this.total);
  final List<Anime> items;
  final int total;
}

class PlayableMedia {
  const PlayableMedia(this.uri, {this.headers = const {}, this.binding});
  final Uri uri;
  final Map<String, String> headers;
  final MediaSourceBinding? binding;
}

@freezed
abstract class MediaSourceBinding with _$MediaSourceBinding {
  const factory MediaSourceBinding({
    required String sourceId,
    required String label,
    required String address,
    @Default(true) bool needsResolution,
    @Default(<String, String>{}) Map<String, String> context,
  }) = _MediaSourceBinding;
  factory MediaSourceBinding.fromJson(Map<String, dynamic> json) =>
      _$MediaSourceBindingFromJson(json);
}

class PlaybackSnapshot {
  const PlaybackSnapshot({
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playing = false,
    this.buffering = false,
    this.completed = false,
    this.error,
  });
  final Duration position;
  final Duration duration;
  final bool playing;
  final bool buffering;
  final bool completed;
  final String? error;
}
