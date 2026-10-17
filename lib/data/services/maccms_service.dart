import 'dart:convert';

import 'package:dio/dio.dart';

import '../../domain/video_source.dart';

class MacCmsService {
  const MacCmsService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> _get(
    VideoSource source,
    Map<String, dynamic> query,
  ) async {
    // Preserve endpoint-specific query parameters, while controlling API action.
    final endpoint = Uri.parse(source.endpoint);
    final response = await _dio.get<dynamic>(
      endpoint.replace(query: '').toString(),
      queryParameters: {...endpoint.queryParameters, ...query, 'at': 'json'},
      options: Options(extra: {'source_id': source.id}),
    );
    final data = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;
    if (data is! Map<String, dynamic> ||
        _int(data['code']) != 1 ||
        data['list'] is! List) {
      throw const FormatException('视频源未返回有效的 MacCMS JSON 数据');
    }
    return data;
  }

  Future<void> check(VideoSource source) async {
    await _get(source, {'ac': 'list', 'pg': 1});
  }

  Future<SourcePage> search(
    VideoSource source,
    String keyword, {
    int page = 1,
  }) async {
    final data = await _get(source, {'ac': 'list', 'wd': keyword, 'pg': page});
    final returnedPage = _int(data['page']);
    if (returnedPage != page ||
        _int(data['pagecount']) < 0 ||
        _int(data['total']) < 0) {
      throw const FormatException('视频源分页信息无效');
    }
    final items = (data['list'] as List).map((item) {
      final row = item as Map<String, dynamic>;
      final id = '${row['vod_id'] ?? ''}';
      if (int.tryParse(id) == null || int.parse(id) <= 0) {
        throw const FormatException('无效的资源编号');
      }
      return SourceTitle(
        id: id,
        title: '${row['vod_name'] ?? ''}',
        year: '${row['vod_year'] ?? ''}',
        remarks: '${row['vod_remarks'] ?? ''}',
        category: '${row['type_name'] ?? ''}',
      );
    }).toList();
    return SourcePage(
      List.unmodifiable(items),
      page: returnedPage,
      pageCount: _int(data['pagecount']),
      total: _int(data['total']),
    );
  }

  Future<List<SourceLine>> lines(VideoSource source, String titleId) async {
    final data = await _get(source, {'ac': 'detail', 'ids': titleId});
    final rows = data['list'] as List;
    final row = rows
        .cast<Map<String, dynamic>>()
        .where((row) => '${row['vod_id']}' == titleId)
        .firstOrNull;
    if (row == null) throw const FormatException('视频源没有返回所选资源');
    final rawNames = '${row['vod_play_from'] ?? ''}';
    final names = rawNames.contains(r'$$$')
        ? rawNames.split(r'$$$')
        : rawNames.split(',');
    final groups = '${row['vod_play_url'] ?? ''}'.split(r'$$$');
    return List.unmodifiable(
      [
        for (var index = 0; index < groups.length; index++)
          SourceLine(
            index < names.length && names[index].isNotEmpty
                ? names[index]
                : '线路 ${index + 1}',
            List.unmodifiable([
              for (final item in groups[index].split('#'))
                if (item.contains(r'$'))
                  SourceEpisode(
                    label: item.substring(0, item.indexOf(r'$')).trim(),
                    address: item.substring(item.indexOf(r'$') + 1).trim(),
                  ),
            ]),
          ),
      ].where((line) => line.episodes.isNotEmpty),
    );
  }

  static int _int(dynamic value) =>
      value is int ? value : int.tryParse('$value') ?? 0;
}
