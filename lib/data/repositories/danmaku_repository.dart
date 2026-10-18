import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/danmaku.dart';
import '../../domain/models.dart';
import '../services/dandanplay_service.dart';

class DandanplayRepository implements DanmakuRepository {
  DandanplayRepository(this._service, [this._preferences]);
  final DandanplayService _service;
  final SharedPreferencesAsync? _preferences;
  final _bindings = <int, DanmakuMatch>{};
  DanmakuOptions _options = const DanmakuOptions();

  @override
  Future<DanmakuOptions> getOptions() async {
    final raw = await _preferences?.getString('danmaku_options_v1');
    if (raw != null) {
      try {
        _options = DanmakuOptions.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } on FormatException {
        /* Use defaults if old settings are damaged. */
      } on TypeError {
        /* Use defaults if old settings are damaged. */
      }
    }
    return _options;
  }

  @override
  Future<void> saveOptions(DanmakuOptions options) async {
    await _preferences?.setString(
      'danmaku_options_v1',
      jsonEncode(options.toJson()),
    );
    _options = options;
  }

  @override
  Future<DanmakuResult> load(
    Anime anime,
    Episode episode, {
    DanmakuMatch? selected,
    bool rematch = false,
    Future<void>? cancelled,
  }) async {
    final cancelToken = CancelToken();
    var finished = false;
    if (cancelled != null) {
      unawaited(
        cancelled.then((_) {
          if (!finished) cancelToken.cancel();
        }),
      );
    }
    try {
      if (!_service.credentials.configured) {
        return const DanmakuResult(message: '此安装包未配置弹弹play凭证');
      }
      final bindingKey = 'danmaku_binding_v1_${anime.id}_${episode.id}';
      var match = selected ?? (rematch ? null : _bindings[episode.id]);
      if (match == null && !rematch) {
        final raw = await _preferences?.getString(bindingKey);
        if (raw != null) {
          try {
            match = DanmakuMatch.fromJson(
              jsonDecode(raw) as Map<String, dynamic>,
            );
          } on FormatException {
            /* Ignore a damaged saved binding. */
          } on TypeError {
            /* Ignore a damaged saved binding. */
          }
        }
      }
      var candidates = <DanmakuMatch>[];
      if (match == null) {
        Map<String, dynamic>? linked;
        try {
          linked = await _service.bangumi(anime.id, cancelToken: cancelToken);
        } on DanmakuException catch (error) {
          if (error.message != '弹弹play未返回可用数据') rethrow;
        }
        final details = linked?['bangumi'];
        if (details is Map) {
          final title = details['animeTitle'] as String? ?? anime.title;
          for (final row in details['episodes'] as List? ?? const []) {
            if (row is! Map || row['episodeId'] is! num) continue;
            candidates.add(
              DanmakuMatch(
                episodeId: (row['episodeId'] as num).toInt(),
                animeTitle: title,
                episodeTitle: row['episodeTitle'] as String? ?? '',
                number: row['episodeNumber'] as String? ?? '',
                seasonId: row['seasonId'] as String? ?? '',
              ),
            );
          }
          // The API explicitly links this Bangumi subject. Match only a unique,
          // normal integer episode number; never guess a special or another season.
          final exact = candidates
              .where(
                (candidate) =>
                    episode.type == 0 &&
                    episode.sort > 0 &&
                    episode.sort == episode.sort.truncateToDouble() &&
                    RegExp(r'^\d+$').hasMatch(candidate.number) &&
                    int.parse(candidate.number) == episode.sort.toInt(),
              )
              .toList();
          if (exact.length == 1) match = exact.single;
        }
        if (candidates.isEmpty) {
          final number =
              episode.type == 0 &&
                  episode.sort > 0 &&
                  episode.sort == episode.sort.truncateToDouble()
              ? episode.sort.toInt().toString()
              : null;
          final searched = await _service.search(
            anime.title,
            number,
            cancelToken: cancelToken,
          );
          for (final item in searched['animes'] as List? ?? const []) {
            if (item is! Map) continue;
            for (final row in item['episodes'] as List? ?? const []) {
              if (row is! Map || row['episodeId'] is! num) continue;
              candidates.add(
                DanmakuMatch(
                  episodeId: (row['episodeId'] as num).toInt(),
                  animeTitle: item['animeTitle'] as String? ?? '',
                  episodeTitle: row['episodeTitle'] as String? ?? '',
                ),
              );
            }
          }
          // Search is only a set of candidates, not a verified subject link.
        }
      }
      if (cancelToken.cancelError case final error?) {
        throw error;
      }
      candidates = candidates
          .where((candidate) => candidate.episodeId > 0)
          .toList();
      if (match == null) {
        return DanmakuResult(
          candidates: List.unmodifiable(candidates),
          message: candidates.isEmpty ? '未找到本集弹幕' : '未能唯一匹配本集，请在弹幕设置中确认',
        );
      }
      if (match.episodeId <= 0) throw const DanmakuException('无效的弹幕库编号');
      final comments = await _service.comments(
        match.episodeId,
        cancelToken: cancelToken,
      );
      if (cancelToken.cancelError case final error?) {
        throw error;
      }
      // Persist only after both the binding and its comments were usable.
      if (selected != null ||
          _bindings[episode.id]?.episodeId != match.episodeId) {
        await _preferences?.setString(bindingKey, jsonEncode(match.toJson()));
        _bindings[episode.id] = match;
      }
      return DanmakuResult(
        match: match,
        comments: comments,
        candidates: List.unmodifiable(candidates),
        message: comments.isEmpty ? '本集暂无弹幕' : '已加载 ${comments.length} 条弹幕',
      );
    } finally {
      finished = true;
    }
  }
}
