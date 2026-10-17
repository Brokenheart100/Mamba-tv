import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'video_source.freezed.dart';
part 'video_source.g.dart';

const animekoOnlineSubscription = 'https://sub.creamycake.org/v1/css1.json';

@freezed
abstract class VideoSource with _$VideoSource {
  const factory VideoSource({
    required String id,
    required String name,
    required String endpoint,
    @Default(true) bool enabled,
    @Default('maccms') String factoryId,
    @Default(<String, dynamic>{}) Map<String, dynamic> arguments,
    String? subscriptionUrl,
    @Default(2) int tier,
  }) = _VideoSource;
  factory VideoSource.fromJson(Map<String, dynamic> json) =>
      _$VideoSourceFromJson(json);
}

@freezed
abstract class SourceTitle with _$SourceTitle {
  const factory SourceTitle({
    required String id,
    required String title,
    @Default('') String year,
    @Default('') String remarks,
    @Default('') String category,
  }) = _SourceTitle;
}

class SourcePage {
  const SourcePage(
    this.items, {
    required this.page,
    required this.pageCount,
    required this.total,
  });
  final List<SourceTitle> items;
  final int page;
  final int pageCount;
  final int total;
}

class SourceEpisode {
  const SourceEpisode({
    required this.label,
    required this.address,
    this.needsResolution = false,
    this.context = const {},
  });
  final String label;
  final String address;
  final bool needsResolution;
  final Map<String, String> context;
  bool get selectable => needsResolution || directlyPlayable;
  bool get directlyPlayable {
    final uri = Uri.tryParse(address);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        RegExp(
          r'\.(m3u8|mp4|mkv|webm|mov|m4v|ts|mpd)$',
          caseSensitive: false,
        ).hasMatch(uri.path);
  }
}

class SourceLine {
  const SourceLine(this.name, this.episodes);
  final String name;
  final List<SourceEpisode> episodes;
}

abstract interface class SourceRepository {
  Future<List<VideoSource>> load();
  Future<void> save(VideoSource source);
  Future<void> remove(String sourceId);
  Future<void> check(VideoSource source);
  Future<SourcePage> search(VideoSource source, String keyword, {int page = 1});
  Future<List<SourceLine>> lines(VideoSource source, String titleId);
  Future<int> importSubscription(String url);
  Future<PlayableMedia> resolve(
    VideoSource source,
    SourceEpisode episode, {
    Future<void>? cancelled,
  });
}
