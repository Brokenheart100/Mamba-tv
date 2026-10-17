import '../models.dart';
import '../repositories.dart';
import '../video_source.dart';

class MissingMediaException implements Exception {
  const MissingMediaException();
}

class PreparedPlayback {
  const PreparedPlayback(this.media, this.start);
  final PlayableMedia media;
  final Duration start;
}

class PreparePlayback {
  const PreparePlayback(this._library);
  final LibraryRepository _library;
  Future<PreparedPlayback> call(Episode episode) async {
    final media = await _library.getMedia(episode.id);
    if (media == null) throw const MissingMediaException();
    final progress = await _library.getProgress(episode.id);
    var start = progress?.position ?? Duration.zero;
    if (progress != null &&
        progress.duration > Duration.zero &&
        start >= progress.duration - const Duration(seconds: 15)) {
      start = Duration.zero;
    }
    return PreparedPlayback(media, start);
  }
}

PlayableMedia parseMediaAddress(String input) {
  final text = input.trim();
  final uri = Uri.tryParse(text);
  if (text.length > 8192 ||
      uri == null ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    throw const FormatException('请输入不含用户名和密码的 HTTPS 视频地址');
  }
  return PlayableMedia(uri);
}

/// Refresh a previously confirmed source/episode selection without searching
/// or guessing a different title, season or chapter.
class RefreshMediaBinding {
  const RefreshMediaBinding(this._library, this._sources);
  final LibraryRepository _library;
  final SourceRepository _sources;
  Future<PlayableMedia> call(
    int episodeId,
    PlayableMedia media, {
    Future<void>? cancelled,
  }) async {
    final binding = media.binding;
    if (binding == null) return media;
    final source = (await _sources.load())
        .where((source) => source.id == binding.sourceId && source.enabled)
        .firstOrNull;
    if (source == null) return media;
    final resolved = await _sources.resolve(
      source,
      SourceEpisode(
        label: binding.label,
        address: binding.address,
        needsResolution: binding.needsResolution,
        context: binding.context,
      ),
      cancelled: cancelled,
    );
    final updated = PlayableMedia(
      resolved.uri,
      headers: resolved.headers,
      binding: binding,
    );
    await _library.bindMedia(episodeId, updated);
    return updated;
  }
}
