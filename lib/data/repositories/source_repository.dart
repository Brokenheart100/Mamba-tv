import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../domain/failure.dart';
import '../../domain/video_source.dart';
import '../services/maccms_service.dart';
import '../services/animeko_source_service.dart';
import '../../domain/models.dart';
import '../../domain/use_cases/prepare_playback.dart';

class PreferencesSourceRepository implements SourceRepository {
  PreferencesSourceRepository(
    this._preferences,
    this._service,
    this._talker, {
    this._animeko,
  });
  final SharedPreferencesAsync _preferences;
  final MacCmsService _service;
  final Talker _talker;
  final AnimekoSourceService? _animeko;
  Future<int>? _initialImport;
  static const storageKey = 'video_sources_v1';
  Future<void> _writes = Future.value();

  @override
  Future<List<VideoSource>> load() async {
    final raw = await _preferences.getString(storageKey);
    if (_animeko != null &&
        await _preferences.getBool('animeko_default_subscription_seeded') !=
            true) {
      await (_initialImport ??= importSubscription(animekoOnlineSubscription)
          .whenComplete(() => _initialImport = null));
      return _readSaved();
    }
    return _decode(raw);
  }

  Future<List<VideoSource>> _readSaved() async =>
      _decode(await _preferences.getString(storageKey));
  List<VideoSource> _decode(String? raw) {
    if (raw == null) return const [];
    final json = jsonDecode(raw) as List;
    return List.unmodifiable(
      json.map((row) => VideoSource.fromJson(row as Map<String, dynamic>)),
    );
  }

  Future<void> _edit(List<VideoSource> Function(List<VideoSource>) change) {
    final operation = _writes.then((_) async {
      final next = change(await _readSaved());
      await _preferences.setString(
        storageKey,
        jsonEncode(next.map((source) => source.toJson()).toList()),
      );
    });
    _writes = operation.catchError((Object _) {});
    return operation;
  }

  @override
  Future<void> save(VideoSource source) {
    validate(source);
    return _edit(
      (sources) => [...sources.where((item) => item.id != source.id), source],
    );
  }

  @override
  Future<void> remove(String sourceId) =>
      _edit((sources) => sources.where((item) => item.id != sourceId).toList());

  static void validate(VideoSource source) {
    final uri = Uri.tryParse(source.endpoint);
    if (source.name.trim().isEmpty ||
        source.id.isEmpty ||
        uri == null ||
        !(source.factoryId == 'maccms'
            ? uri.scheme == 'https'
            : {'http', 'https'}.contains(uri.scheme)) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment ||
        source.endpoint.length > 8192) {
      throw const AppFailure('请输入名称和不含用户名、密码或片段的有效接口地址');
    }
  }

  Future<T> _request<T>(
    String action,
    VideoSource source,
    Future<T> Function() request,
  ) async {
    validate(source);
    try {
      return await request();
    } catch (error, stack) {
      _talker.error('$action (${error.runtimeType})', null, stack);
      throw AppFailure(
        error is DioException
            ? '视频源连接失败，请检查接口地址或稍后重试'
            : error is AppFailure
            ? error.message
            : '视频源规则或返回数据无法读取，请更新订阅或换一个数据源',
      );
    }
  }

  @override
  Future<void> check(VideoSource source) => _request('检测视频源', source, () async {
    if (source.factoryId == 'maccms') {
      await _service.check(source);
    } else {
      final result = await _animeko!.search(source, '葬送的芙莉莲');
      if (result.items.isEmpty) {
        throw const AppFailure('测试搜索没有返回作品，站点可能需要验证或规则已失效');
      }
    }
  });
  @override
  Future<SourcePage> search(
    VideoSource source,
    String keyword, {
    int page = 1,
  }) => _request(
    '搜索视频源',
    source,
    () => source.factoryId == 'maccms'
        ? _service.search(source, keyword, page: page)
        : _animeko!.search(source, keyword, page: page),
  );
  @override
  Future<List<SourceLine>> lines(VideoSource source, String titleId) =>
      _request(
        '读取播放线路',
        source,
        () => source.factoryId == 'maccms'
            ? _service.lines(source, titleId)
            : _animeko!.lines(source, titleId),
      );

  @override
  Future<int> importSubscription(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (_animeko == null ||
        uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment) {
      throw const AppFailure('请输入有效的 HTTPS Animeko 在线订阅地址');
    }
    final sources = await _animeko.subscription(uri.toString());
    for (final source in sources) {
      validate(source);
    }
    await _edit((existing) {
      final old = {for (final source in existing) source.id: source};
      return [
        ...sources.map(
          (source) => source.copyWith(enabled: old[source.id]?.enabled ?? true),
        ),
        ...existing.where(
          (source) =>
              source.subscriptionUrl != uri.toString() &&
              !sources.any((next) => next.id == source.id),
        ),
      ];
    });
    _talker.info('Animeko 订阅更新完成 · ${sources.length} 个数据源');
    if (uri.toString() == animekoOnlineSubscription) {
      await _preferences.setBool('animeko_default_subscription_seeded', true);
    }
    return sources.length;
  }

  @override
  Future<PlayableMedia> resolve(
    VideoSource source,
    SourceEpisode episode, {
    Future<void>? cancelled,
  }) => _request('解析视频资源', source, () async {
    if (source.factoryId == 'maccms') return parseMediaAddress(episode.address);
    return _animeko!.resolve(source, episode, cancelled: cancelled);
  });
}
