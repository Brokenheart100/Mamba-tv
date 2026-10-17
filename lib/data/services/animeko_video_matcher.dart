import '../../domain/video_source.dart';
import 'animeko_source_service.dart';

class AnimekoVideoMatcher {
  AnimekoVideoMatcher(VideoSource source)
    : _config = AnimekoSourceService.map(
        AnimekoSourceService.config(source)['matchVideo'],
      ) {
    _video = RegExp(
      '${_config['matchVideoUrl'] ?? r'\.(m3u8|mp4|mkv|webm)(\?|$)'}',
    );
    final nested = '${_config['matchNestedUrl'] ?? ''}';
    _nested = nested.isEmpty ? null : RegExp(nested);
  }
  final Map<String, dynamic> _config;
  late final RegExp _video;
  late final RegExp? _nested;

  bool isNestedPage(String url) =>
      _config['enableNestedUrl'] != false && _nested?.hasMatch(url) == true;

  String? match(String url) {
    if (isNestedPage(url)) return null;
    final found = _video.firstMatch(url);
    if (found == null) return null;
    final captured = found.groupNames.contains('v')
        ? found.namedGroup('v')
        : null;
    final uri = Uri.tryParse(captured ?? url);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri.toString();
  }
}
