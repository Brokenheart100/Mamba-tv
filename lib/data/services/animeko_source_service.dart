import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:json_path/json_path.dart';

import '../../domain/failure.dart';
import '../../domain/models.dart';
import '../../domain/video_source.dart';

typedef ResolveWebPage = Future<PlayableMedia> Function(
  VideoSource source,
  SourceEpisode episode, {
  Future<void>? cancelled,
});

/// Reads Animeko's public subscription and rule contracts; rules are not
/// converted into a different site's API or hard-coded per provider.
class AnimekoSourceService {
  AnimekoSourceService(this._dio, {this.resolveWebPage});
  final Dio _dio;
  final ResolveWebPage? resolveWebPage;
  final _requests = <String, Future<void>>{};
  final _lastRequest = <String, DateTime>{};

  static Map<String, dynamic> map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
  static Map<String, dynamic> config(VideoSource source) =>
      map(source.arguments['searchConfig']);
  static List<dynamic> select(dynamic data, String expression) =>
      expression.isEmpty
      ? []
      : JsonPath(expression).read(data).map((match) => match.value).toList();
  static String field(dynamic data, String expression) =>
      select(data, expression).firstOrNull?.toString() ?? '';

  Future<List<VideoSource>> subscription(String url) async {
    final data = await _dio.get<dynamic>(url);
    return decodeSubscription(data.data, url);
  }

  static List<VideoSource> decodeSubscription(dynamic raw, String url) {
    final root = map(raw is String ? jsonDecode(raw) : raw);
    if ((root['schemaVersion'] as num? ?? 1) > 2) {
      throw const AppFailure('订阅格式版本较新，请升级客户端');
    }
    final rows =
        root['mediaSources'] ??
        map(root['exportedMediaSourceDataList'])['mediaSources'];
    if (rows is! List) throw const AppFailure('这不是 Animeko 数据源订阅');
    final ids = <String>{};
    final sources = <VideoSource>[];
    for (final value in rows) {
      final row = map(value);
      final factory = '${row['factoryId'] ?? ''}';
      if (!{'web-selector', 'json-api'}.contains(factory)) {
        throw AppFailure('暂不支持订阅中的 $factory 数据源');
      }
      final args = map(row['arguments']);
      final search = map(args['searchConfig']);
      final endpoint = factory == 'json-api'
          ? '${search['baseUrl'] ?? ''}'
          : '${search['searchUrl'] ?? ''}';
      final id = 'animeko:$factory:${row['id']}';
      if (row['id'] == null ||
          !ids.add(id) ||
          endpoint.isEmpty ||
          args['name'] is! String) {
        throw const AppFailure('订阅中存在无效或重复的数据源');
      }
      sources.add(
        VideoSource(
          id: id,
          name: args['name'] as String,
          endpoint: endpoint,
          factoryId: factory,
          arguments: args,
          subscriptionUrl: url,
          tier: (args['tier'] as num?)?.toInt() ?? 2,
        ),
      );
    }
    if (sources.isEmpty) throw const AppFailure('订阅没有在线数据源');
    return List.unmodifiable(sources);
  }

  static Map<String, String> parseHeaders(String raw) {
    final headers = <String, String>{};
    for (final line in raw.split('\n')) {
      final separator = line.indexOf(':');
      if (separator > 0) {
        headers[line.substring(0, separator).trim()] = line
            .substring(separator + 1)
            .trim();
      }
    }
    return headers;
  }

  Future<dynamic> _request(
    VideoSource source,
    String url, {
    String method = 'GET',
    dynamic body,
    Map<String, String> headers = const {},
    CancelToken? cancelToken,
  }) async {
    final previous = _requests[source.id] ?? Future<void>.value();
    final operation = previous.then((_) async {
      final interval =
          (config(source)['requestInterval'] as num?)?.toInt() ?? 3000;
      final last = _lastRequest[source.id];
      if (last != null) {
        final remaining =
            interval.clamp(0, 10000) -
            DateTime.now().difference(last).inMilliseconds;
        if (remaining > 0) {
          await Future<void>.delayed(Duration(milliseconds: remaining));
        }
      }
      if (cancelToken?.isCancelled == true) throw cancelToken!.cancelError!;
      _lastRequest[source.id] = DateTime.now();
      final response = await _dio.request<dynamic>(
        url,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          method: method,
          headers: headers,
          extra: {'source_id': source.id},
        ),
      );
      return response.data;
    });
    _requests[source.id] = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return operation;
  }

  static Map<String, String> pageHeaders(VideoSource source) {
    final cfg = config(source);
    final match = map(cfg['matchVideo']);
    final userAgent = '${cfg['userAgent'] ?? ''}'.trim();
    return {
      'User-Agent': userAgent.isNotEmpty ? userAgent : 'Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 Chrome/130.0.0.0 Safari/537.36',
      if ('${match['cookies'] ?? ''}'.isNotEmpty)
        'Cookie': '${match['cookies']}',
    };
  }

  static Map<String, String> videoHeaders(VideoSource source) {
    final cfg = config(source);
    final legacy = map(map(cfg['matchVideo'])['addHeadersToVideo']);
    final userAgent = '${cfg['userAgent'] ?? ''}'.trim();
    return {
      'User-Agent': userAgent.isNotEmpty
          ? userAgent
          : '${legacy['userAgent'] ?? pageHeaders(source)['User-Agent']}',
      'Referer': '${legacy['referer'] ?? ''}',
    };
  }

  Future<dynamic> _jsonRequest(
    VideoSource source,
    Map<String, dynamic> request,
    Map<String, dynamic> values, {
    CancelToken? cancelToken,
  }) {
    String expand(String value, {bool json = false}) {
      for (final entry in values.entries) {
        final replacement = json
            ? jsonEncode(entry.value)
                  .replaceFirst(RegExp(r'^"'), '')
                  .replaceFirst(RegExp(r'"$'), '')
            : Uri.encodeComponent('${entry.value}');
        value = value.replaceAll('{${entry.key}}', replacement);
      }
      return value;
    }

    final cfg = config(source);
    final url = Uri.parse('${cfg['baseUrl']}')
        .resolve(expand('${request['url']}'))
        .toString();
    final rawBody = '${request['body'] ?? ''}';
    return _request(
      source,
      url,
      method: '${request['method'] ?? 'GET'}',
      body: rawBody.isEmpty ? null : jsonDecode(expand(rawBody, json: true)),
      headers: {
        ...parseHeaders('${cfg['headers'] ?? ''}'),
        ...parseHeaders('${request['headers'] ?? ''}'),
        'Content-Type': 'application/json',
      },
      cancelToken: cancelToken,
    ).then((value) => value is String ? jsonDecode(value) : value);
  }

  Future<SourcePage> search(
    VideoSource source,
    String keyword, {
    int page = 1,
  }) async {
    final cfg = config(source);
    if (source.factoryId == 'json-api') {
      final search = map(cfg['search']);
      final size = (search['pageSize'] as num?)?.toInt() ?? 50;
      final data = await _jsonRequest(source, map(search['request']), {
        'keyword': keyword,
        'page': page,
        'pageSize': size,
      });
      final rows = select(data, '${search['selectItems'] ?? r'$[*]'}');
      final titles = rows
          .map(
            (row) => SourceTitle(
              id: field(row, '${search['selectId']}'),
              title: field(row, '${search['selectName']}'),
            ),
          )
          .where((title) => title.id.isNotEmpty && title.title.isNotEmpty)
          .toList();
      return SourcePage(
        List.unmodifiable(titles),
        page: page,
        pageCount: titles.length >= size ? page + 1 : page,
        total: (page - 1) * size + titles.length,
      );
    }
    if (page != 1) return const SourcePage([], page: 1, pageCount: 1, total: 0);
    var query = keyword.trim();
    final auto = map(cfg['autoMatch']);
    if ((auto['searchRemoveSpecial'] ?? cfg['searchRemoveSpecial']) == true) {
      query = query.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ');
    }
    if ((auto['searchUseOnlyFirstWord'] ?? cfg['searchUseOnlyFirstWord']) ==
        true) {
      query = query.split(RegExp(r'\s+')).first;
    }
    final url = '${cfg['searchUrl']}'.replaceAll(
      '{keyword}',
      Uri.encodeComponent(query),
    );
    final data = await _request(source, url, headers: pageHeaders(source));
    return parseSubjects(source, data is String ? data : jsonEncode(data));
  }

  static String _base(VideoSource source) {
    final cfg = config(source);
    final raw = '${cfg['rawBaseUrl'] ?? ''}';
    return raw.isNotEmpty ? raw : Uri.parse(source.endpoint).origin;
  }

  static String _link(String base, String raw, [String? template]) {
    final expanded = template == null || template.isEmpty
        ? raw
        : template.replaceAll('{value}', raw);
    final uri = Uri.parse(base).resolve(expanded);
    if (!{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw const FormatException('数据源返回无效的网页链接');
    }
    return uri.toString();
  }

  static SourcePage parseSubjects(VideoSource source, String content) {
    final cfg = config(source);
    final format = '${cfg['subjectFormatId'] ?? 'a'}';
    final base = _base(source);
    final subjects = <SourceTitle>[];
    if (format == 'json-path-indexed') {
      final rule = map(cfg['selectorSubjectFormatJsonPathIndexed']);
      final data = jsonDecode(content);
      final names = select(data, '${rule['selectNames']}');
      final links = select(data, '${rule['selectLinks']}');
      for (var i = 0; i < names.length && i < links.length; i++) {
        subjects.add(
          SourceTitle(
            id: _link(base, '${links[i]}', rule['linkTemplate'] as String?),
            title: '${names[i]}',
          ),
        );
      }
    } else {
      final document = html.parse(content);
      if (format == 'a') {
        final rule = map(cfg['selectorSubjectFormatA']);
        for (final item in document.querySelectorAll(
          '${rule['selectLists'] ?? 'div.video-info-header > a'}',
        )) {
          final title = item.attributes['title']?.trim();
          final href = item.attributes['href'] ?? '';
          if (href.isNotEmpty) {
            subjects.add(
              SourceTitle(
                id: _link(base, href, rule['linkTemplate'] as String?),
                title: title != null && title.isNotEmpty
                    ? title
                    : item.text.trim(),
              ),
            );
          }
        }
      } else if (format == 'indexed') {
        final rule = map(cfg['selectorSubjectFormatIndexed']);
        final names = document
            .querySelectorAll('${rule['selectNames']}')
            .map((element) => element.text.trim())
            .where((name) => name.isNotEmpty)
            .toList();
        final links = document
            .querySelectorAll('${rule['selectLinks']}')
            .map((element) => element.attributes['href'] ?? '')
            .where((href) => href.isNotEmpty)
            .toList();
        for (var i = 0; i < names.length && i < links.length; i++) {
          subjects.add(
            SourceTitle(
              id: _link(base, links[i], rule['linkTemplate'] as String?),
              title: names[i],
            ),
          );
        }
      } else {
        throw AppFailure('不支持网页搜索格式 $format');
      }
    }
    final seen = <String>{};
    final unique = subjects
        .where((subject) => subject.title.isNotEmpty && seen.add(subject.id))
        .toList();
    return SourcePage(
      List.unmodifiable(unique),
      page: 1,
      pageCount: 1,
      total: unique.length,
    );
  }

  Future<List<SourceLine>> lines(VideoSource source, String titleId) async {
    final cfg = config(source);
    if (source.factoryId == 'json-api') {
      final subject = map(cfg['subject']);
      final data = await _jsonRequest(source, map(subject['request']), {
        'id': titleId,
      });
      final format = '${subject['channelFormatId'] ?? 'grouped'}';
      if (format != 'grouped') throw AppFailure('不支持 JSON API 线路格式 $format');
      final grouped = map(subject['channelFormatGrouped']);
      final episodes = map(subject['episodes']);
      return List.unmodifiable([
        for (final channel in select(data, '${grouped['selectChannels']}'))
          SourceLine(
            field(channel, '${grouped['selectChannelName']}'),
            List.unmodifiable([
              for (final row in select(
                channel,
                '${episodes['selectEpisodes']}',
              ))
                SourceEpisode(
                  label:
                      '${field(row, '${episodes['selectSort']}')} ${field(row, '${episodes['selectName']}')}'
                          .trim(),
                  address: field(row, '${episodes['selectId']}'),
                  needsResolution: true,
                  context: {
                    'id': field(row, '${episodes['selectId']}'),
                    'subjectId': titleId,
                    'channel': field(
                      channel,
                      '${grouped['selectChannelName']}',
                    ),
                  },
                ),
            ]),
          ),
      ]);
    }
    final content = await _request(
      source,
      titleId,
      headers: pageHeaders(source),
    );
    return parseLines(source, '$content', titleId);
  }

  static List<SourceLine> parseLines(
    VideoSource source,
    String content,
    String subjectUrl,
  ) {
    final document = html.parse(content);
    final cfg = config(source);
    final format = '${cfg['channelFormatId'] ?? 'no-channel'}';
    List<SourceEpisode> episodes(
      Element container,
      String namesSelector,
      String linksSelector,
      String channel,
    ) {
      final names = container.querySelectorAll(namesSelector);
      final links = linksSelector.isEmpty
          ? null
          : container.querySelectorAll(linksSelector);
      return List.unmodifiable([
        for (var i = 0; i < names.length; i++)
          if ((links == null ? names[i] : links.elementAtOrNull(i))
                  ?.attributes['href']
                  ?.isNotEmpty ==
              true)
            SourceEpisode(
              label: names[i].text.trim(),
              address: _link(
                subjectUrl,
                (links == null ? names[i] : links[i]).attributes['href']!,
              ),
              needsResolution: true,
              context: {'channel': channel},
            ),
      ]);
    }

    if (format == 'no-channel') {
      final rule = map(cfg['selectorChannelFormatNoChannel']);
      return [
        SourceLine(
          '默认线路',
          episodes(
            document.documentElement!,
            '${rule['selectEpisodes']}',
            '${rule['selectEpisodeLinks'] ?? ''}',
            '默认线路',
          ),
        ),
      ];
    }
    if (format != 'index-grouped') throw AppFailure('不支持网页线路格式 $format');
    final rule = map(cfg['selectorChannelFormatFlattened']);
    final names = document.querySelectorAll('${rule['selectChannelNames']}');
    final lists = document.querySelectorAll('${rule['selectEpisodeLists']}');
    final expression = '${rule['matchChannelName'] ?? ''}';
    final regex = expression.isEmpty ? null : RegExp(expression);
    final results = <SourceLine>[];
    for (var i = 0; i < names.length && i < lists.length; i++) {
      final text = names[i].text.trim();
      final match = regex?.firstMatch(text);
      if (regex != null && match == null) continue;
      final channel = match == null
          ? text
          : match.groupNames.contains('ch')
          ? match.namedGroup('ch') ?? match.group(0)!
          : match.group(0)!;
      results.add(
        SourceLine(
          channel,
          episodes(
            lists[i],
            '${rule['selectEpisodesFromList']}',
            '${rule['selectEpisodeLinksFromList'] ?? ''}',
            channel,
          ),
        ),
      );
    }
    return List.unmodifiable(results);
  }

  Future<PlayableMedia> resolve(
    VideoSource source,
    SourceEpisode episode, {
    Future<void>? cancelled,
  }) async {
    if (source.factoryId == 'web-selector') {
      if (resolveWebPage == null) {
        throw const AppFailure('此资源需要 Android WebView 解析，请在安卓应用中播放');
      }
      return resolveWebPage!(source, episode, cancelled: cancelled);
    }
    final token = CancelToken();
    if (cancelled != null) {
      unawaited(
        cancelled.then((_) {
          if (!token.isCancelled) token.cancel();
        }),
      );
    }
    final play = map(config(source)['play']);
    final data = await _jsonRequest(
      source,
      map(play['request']),
      episode.context,
      cancelToken: token,
    );
    final candidates = select(data, '${play['selectCandidates']}');
    final channel = episode.context['channel'];
    final matched = candidates
        .where(
          (candidate) =>
              field(candidate, '${play['selectCandidateChannel']}') == channel,
        )
        .firstOrNull;
    final candidate =
        matched ??
        (play['fallbackToFirstCandidate'] == true
            ? candidates.firstOrNull
            : null);
    if (candidate == null) throw const AppFailure('该播放线路没有返回可用的视频地址');
    final uri = Uri.tryParse(field(candidate, '${play['selectVideoUrl']}'));
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw const AppFailure('数据源返回的视频地址无效');
    }
    return PlayableMedia(
      uri,
      headers: {
        if ('${play['referer'] ?? ''}'.isNotEmpty)
          'Referer': '${play['referer']}',
      },
    );
  }
}
