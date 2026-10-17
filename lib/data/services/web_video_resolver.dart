import 'dart:async';
import 'dart:io' as io;
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../domain/failure.dart';
import '../../domain/models.dart';
import '../../domain/video_source.dart';
import 'animeko_source_service.dart';
import 'animeko_video_matcher.dart';

class WebVideoResolver {
  WebVideoResolver(this._cookies);
  final CookieJar _cookies;

  /// Native WebView executes the upstream player's JavaScript. We observe the
  /// same network-resource URLs that Animeko's matcher consumes.
  Future<PlayableMedia> resolve(
    VideoSource source,
    SourceEpisode episode, {
    Future<void>? cancelled,
  }) async {
    final cfg = AnimekoSourceService.config(source);
    final match = AnimekoSourceService.map(cfg['matchVideo']);
    final headers = AnimekoSourceService.pageHeaders(source);
    final page = WebUri(episode.address);
    final cookieManager = CookieManager.instance();
    final jarCookies = await _cookies.loadForRequest(
      Uri.parse(episode.address),
    );
    final configured = '${match['cookies'] ?? ''}'
        .split(';')
        .where((part) => part.contains('='))
        .map((part) {
          final at = part.indexOf('=');
          return io.Cookie(
            part.substring(0, at).trim(),
            part.substring(at + 1).trim(),
          );
        });
    for (final cookie in [...jarCookies, ...configured]) {
      await cookieManager.setCookie(
        url: page,
        name: cookie.name,
        value: cookie.value,
      );
    }
    final result = Completer<String>();
    final matcher = AnimekoVideoMatcher(source);
    void consider(String? url) {
      if (url == null || result.isCompleted) return;
      final video = matcher.match(url);
      if (video != null) result.complete(video);
    }

    final webView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: page, headers: headers),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldInterceptRequest: true,
        useOnLoadResource: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: headers['User-Agent'],
      ),
      shouldInterceptRequest: (controller, request) async {
        consider(request.url.toString());
        return null;
      },
      onLoadResource: (controller, resource) {
        consider(resource.url?.toString());
      },
      onLoadStop: (controller, url) async {
        try {
          final urls = await controller.evaluateJavascript(
            source: "JSON.stringify([...document.querySelectorAll('video,source')].map(v=>v.currentSrc||v.src).filter(Boolean))",
          );
          if (urls is String) {
            for (final url in jsonDecode(urls) as List) {
              consider('$url');
            }
          }
          await controller.evaluateJavascript(
            source: "document.querySelectorAll('video').forEach(v=>{v.muted=true;v.play().catch(()=>{});})",
          );
        } catch (_) {
          /* Cross-origin players are still observed on the network. */
        }
      },
    );
    try {
      await webView.run();
      final futures = <Future<String>>[
        result.future.timeout(
          const Duration(seconds: 35),
          onTimeout: () => throw const AppFailure('播放页解析超时，请换一个线路；站点可能需要验证'),
        ),
      ];
      if (cancelled != null) {
        futures.add(cancelled.then((_) => throw const AppFailure('已取消视频解析')));
      }
      final address = await Future.any(futures);
      final cookies = await cookieManager.getCookies(url: WebUri(address));
      return PlayableMedia(
        Uri.parse(address),
        headers: {
          ...AnimekoSourceService.videoHeaders(source),
          'Sec-Ch-Ua-Mobile': '?0',
          'Sec-Ch-Ua-Platform': 'macOS',
          'Sec-Fetch-Dest': 'video',
          'Sec-Fetch-Mode': 'no-cors',
          'Sec-Fetch-Site': 'cross-site',
          if (cookies.isNotEmpty)
            'Cookie': cookies
                .map((cookie) => '${cookie.name}=${cookie.value}')
                .join('; '),
        },
      );
    } finally {
      await webView.dispose();
    }
  }
}
