import 'models.dart';

enum DanmakuMode { scroll, bottom, top }

class DanmakuException implements Exception {
  const DanmakuException(this.message);
  final String message;
  @override
  String toString() => message;
}

class DanmakuComment {
  const DanmakuComment({
    required this.id,
    required this.timeMs,
    required this.text,
    this.color = 0xffffff,
    this.mode = DanmakuMode.scroll,
  });
  final int id;
  final int timeMs;
  final String text;
  final int color;
  final DanmakuMode mode;
}

class DanmakuMatch {
  const DanmakuMatch({
    required this.episodeId,
    required this.animeTitle,
    required this.episodeTitle,
    this.number = '',
    this.seasonId = '',
  });
  final int episodeId;
  final String animeTitle;
  final String episodeTitle;
  final String number;
  final String seasonId;
  Map<String, Object> toJson() => {
    'episodeId': episodeId,
    'animeTitle': animeTitle,
    'episodeTitle': episodeTitle,
    'number': number,
    'seasonId': seasonId,
  };
  factory DanmakuMatch.fromJson(Map<String, dynamic> json) => DanmakuMatch(
    episodeId: (json['episodeId'] as num).toInt(),
    animeTitle: json['animeTitle'] as String? ?? '',
    episodeTitle: json['episodeTitle'] as String? ?? '',
    number: json['number'] as String? ?? '',
    seasonId: json['seasonId'] as String? ?? '',
  );
}

class DanmakuResult {
  const DanmakuResult({
    this.comments = const [],
    this.candidates = const [],
    this.match,
    this.message = '弹幕等待加载',
  });
  final List<DanmakuComment> comments;
  final List<DanmakuMatch> candidates;
  final DanmakuMatch? match;
  final String message;
}

class DanmakuOptions {
  const DanmakuOptions({
    this.enabled = true,
    this.opacity = .8,
    this.fontSize = 24,
    this.area = .5,
    this.offsetMs = 0,
  });
  final bool enabled;
  final double opacity;
  final double fontSize;
  final double area;
  // Positive values delay comments relative to the video.
  final int offsetMs;
  DanmakuOptions copyWith({
    bool? enabled,
    double? opacity,
    double? fontSize,
    double? area,
    int? offsetMs,
  }) => DanmakuOptions(
    enabled: enabled ?? this.enabled,
    opacity: (opacity ?? this.opacity).clamp(.2, 1),
    fontSize: (fontSize ?? this.fontSize).clamp(16, 40),
    area: (area ?? this.area).clamp(.25, 1),
    offsetMs: (offsetMs ?? this.offsetMs).clamp(-60000, 60000),
  );
  Map<String, Object> toJson() => {
    'enabled': enabled,
    'opacity': opacity,
    'fontSize': fontSize,
    'area': area,
    'offsetMs': offsetMs,
  };
  factory DanmakuOptions.fromJson(Map<String, dynamic> json) =>
      const DanmakuOptions().copyWith(
        enabled: json['enabled'] as bool?,
        opacity: (json['opacity'] as num?)?.toDouble(),
        fontSize: (json['fontSize'] as num?)?.toDouble(),
        area: (json['area'] as num?)?.toDouble(),
        offsetMs: (json['offsetMs'] as num?)?.toInt(),
      );
}

abstract interface class DanmakuRepository {
  Future<DanmakuOptions> getOptions();
  Future<void> saveOptions(DanmakuOptions options);
  Future<DanmakuResult> load(
    Anime anime,
    Episode episode, {
    DanmakuMatch? selected,
    bool rematch = false,
    Future<void>? cancelled,
  });
}

/// Cursor over a sorted comment list; rendering and track allocation belong to
/// the third-party renderer. Seeking skips old comments instead of bursting them.
class DanmakuTimeline {
  DanmakuTimeline(this.comments);
  final List<DanmakuComment> comments;
  int _index = 0;
  int? _previousMs;
  void reset(int positionMs) {
    var low = 0;
    var high = comments.length;
    final threshold = positionMs - 150;
    while (low < high) {
      final middle = (low + high) ~/ 2;
      if (comments[middle].timeMs < threshold) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    _index = low;
    _previousMs = positionMs - 151;
  }

  List<DanmakuComment> advance(int positionMs) {
    final previous = _previousMs;
    if (previous == null ||
        positionMs < previous ||
        positionMs - previous > 2000) {
      reset(positionMs);
    }
    final due = <DanmakuComment>[];
    while (_index < comments.length && comments[_index].timeMs <= positionMs) {
      final comment = comments[_index++];
      // Bound per-frame work; the renderer also manages collisions and density.
      if (due.length < 16) due.add(comment);
    }
    _previousMs = positionMs;
    return due;
  }
}
