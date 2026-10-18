import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../domain/danmaku.dart';

class DandanplayCredentials {
  const DandanplayCredentials(this.appId, this.appSecret);
  const DandanplayCredentials.fromEnvironment()
    : appId = const String.fromEnvironment('DANDANPLAY_APP_ID'),
      appSecret = const String.fromEnvironment('DANDANPLAY_APP_SECRET');
  final String appId;
  final String appSecret;
  bool get configured => appId.isNotEmpty && appSecret.isNotEmpty;
}

class DandanplayService {
  DandanplayService(this._dio, this.credentials, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final Dio _dio;
  final DandanplayCredentials credentials;
  final DateTime Function() _now;
  final _cache = <String, ({DateTime at, Map<String, dynamic> data})>{};
  ({DateTime time, Stopwatch elapsed})? _serverClock;

  Map<String, String> signedHeaders(String path) {
    final clock = _serverClock;
    final now = clock == null ? _now() : clock.time.add(clock.elapsed.elapsed);
    final timestamp = (now.toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    return {
      'X-AppId': credentials.appId,
      'X-Timestamp': timestamp,
      'X-Signature': base64Encode(
        sha256
            .convert(
              utf8.encode(
                '${credentials.appId}$timestamp$path${credentials.appSecret}',
              ),
            )
            .bytes,
      ),
    };
  }

  Future<Map<String, dynamic>> bangumi(
    int subjectId, {
    CancelToken? cancelToken,
  }) => _get('/api/v2/bangumi/bgmtv/$subjectId', cancelToken: cancelToken);

  Future<Map<String, dynamic>> search(
    String keyword,
    String? episode, {
    CancelToken? cancelToken,
  }) => _get(
    '/api/v2/search/episodes',
    query: {'anime': keyword, 'episode': ?episode, 'v2': true},
    cancelToken: cancelToken,
  );

  Future<List<DanmakuComment>> comments(
    int episodeId, {
    CancelToken? cancelToken,
  }) async => parseComments(
    await _get(
      '/api/v2/comment/$episodeId',
      query: {'withRelated': true, 'chConvert': 1},
      cancelToken: cancelToken,
    ),
  );

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    if (!credentials.configured) {
      throw const DanmakuException('此安装包未配置弹弹play凭证，请使用已配置凭证的构建');
    }
    final uri = Uri.https(
      'api.dandanplay.net',
      path,
      query?.map((key, value) => MapEntry(key, value.toString())),
    );
    final key = uri.toString();
    final cached = _cache[key];
    final cacheAge = cached == null ? null : _now().difference(cached.at);
    if (cached != null &&
        cacheAge != null &&
        !cacheAge.isNegative &&
        cacheAge < const Duration(hours: 4)) {
      if (cancelToken?.cancelError case final error?) {
        throw error;
      }
      return cached.data;
    }
    var target = uri;
    var redirects = 0;
    var clockRetried = false;
    while (redirects <= 3) {
      final response = await _dio.getUri<dynamic>(
        target,
        cancelToken: cancelToken,
        options: Options(
          followRedirects: false,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 500,
          headers: redirects == 0 ? signedHeaders(path) : <String, String>{},
          extra: {'source_id': 'dandanplay'},
        ),
      );
      final status = response.statusCode ?? 0;
      if (status >= 300 && status < 400) {
        final location = response.headers.value('location');
        if (location == null) throw const DanmakuException('弹幕服务返回了无效跳转');
        target = target.resolve(location);
        if (target.scheme != 'https' || target.userInfo.isNotEmpty) {
          throw const DanmakuException('弹幕服务返回了不安全的跳转');
        }
        // CDN requests never carry the API signature or application credentials.
        redirects++;
        continue;
      }
      if (status == 401 || status == 403) {
        if (redirects > 0) {
          throw const DanmakuException('弹幕加速服务拒绝访问，请稍后重试');
        }
        final reason = response.headers.value('x-error-message');
        if (reason == 'Invalid Timestamp' && !clockRetried) {
          final date = response.headers.value(HttpHeaders.dateHeader);
          if (date != null) {
            try {
              // Trust only the original HTTPS API response, never a CDN Date.
              final serverTime = HttpDate.parse(date);
              _serverClock?.elapsed.stop();
              _serverClock = (time: serverTime, elapsed: Stopwatch()..start());
              clockRetried = true;
              continue;
            } on HttpException {
              // Invalid/missing server time must not cause repeated requests.
            }
          }
        }
        throw DanmakuException(_authenticationMessage(reason));
      }
      if (status == 404 && path.startsWith('/api/v2/bangumi/bgmtv/')) {
        throw const DanmakuException('弹弹play未返回可用数据');
      }
      if (status != 200) throw const DanmakuException('弹幕服务暂时不可用，请稍后重试');
      final raw = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      if (raw is! Map) throw const DanmakuException('弹幕响应格式不正确');
      final data = Map<String, dynamic>.from(raw);
      if (data['success'] == false) {
        // A missing Bangumi link may be resolved by the search UI. Never cache errors.
        throw const DanmakuException('弹弹play未返回可用数据');
      }
      if (_cache.length >= 12) _cache.remove(_cache.keys.first);
      _cache[key] = (at: _now(), data: data);
      return data;
    }
    throw const DanmakuException('弹幕服务跳转次数过多');
  }

  static String _authenticationMessage(String? reason) => switch (reason) {
    'Invalid Timestamp' => '设备时间与弹幕服务器不同步，请在系统设置中开启自动日期和时间后重试',
    'Missing Authentication Headers' => '弹幕鉴权失败：请求缺少应用鉴权信息，请检查构建配置',
    'Invalid AppId' || 'Invalid AppSecret' => '弹幕鉴权失败：应用凭证无效，请检查构建配置',
    'Invalid Signature' => '弹幕鉴权失败：签名不匹配，请检查应用凭证和构建配置',
    _ => '弹幕鉴权失败，请检查应用状态、额度或网络访问限制',
  };

  static List<DanmakuComment> parseComments(Map<String, dynamic> json) {
    final raw = json['comments'];
    if (raw == null && json['count'] == 0) return const [];
    if (raw is! List) throw const DanmakuException('弹幕列表格式不正确');
    final comments = <DanmakuComment>[];
    final seen = <String>{};
    for (final item in raw) {
      if (item is! Map || item['p'] is! String || item['m'] is! String) {
        continue;
      }
      final fields = (item['p'] as String).split(',');
      if (fields.length < 3) continue;
      final seconds = double.tryParse(fields[0]);
      final mode = switch (int.tryParse(fields[1])) {
        1 => DanmakuMode.scroll,
        4 => DanmakuMode.bottom,
        5 => DanmakuMode.top,
        _ => null,
      };
      final color = int.tryParse(fields[2]);
      final text = (item['m'] as String).trim();
      if (seconds == null ||
          !seconds.isFinite ||
          seconds < 0 ||
          seconds > 86400 ||
          mode == null ||
          color == null ||
          color < 0 ||
          color > 0xffffff ||
          text.isEmpty) {
        continue;
      }
      final ms = (seconds * 1000).round();
      final dedupe = '$ms|${mode.name}|$color|$text';
      if (!seen.add(dedupe)) continue;
      comments.add(
        DanmakuComment(
          id: item['cid'] is num ? (item['cid'] as num).toInt() : 0,
          timeMs: ms,
          text: text.length > 300 ? text.substring(0, 300) : text,
          color: color,
          mode: mode,
        ),
      );
      if (comments.length >= 100000) break;
    }
    comments.sort((a, b) => a.timeMs.compareTo(b.timeMs));
    return List.unmodifiable(comments);
  }
}
