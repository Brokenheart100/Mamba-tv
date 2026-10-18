import 'package:dio/dio.dart';

import '../../domain/anime_filter.dart';
import '../../domain/bangumi_discovery.dart';
import 'bangumi_discovery_dto.dart';
import 'bangumi_dto.dart';

class BangumiService {
  const BangumiService(this._dio);
  final Dio _dio;
  Future<List<CalendarDayDto>> calendarDays() async =>
      ((await _dio.get<List<dynamic>>('/calendar')).data ?? [])
          .map((row) => CalendarDayDto.fromJson(row as Map<String, dynamic>))
          .toList();

  Future<List<RelatedAnimeDto>> relations(int id) async =>
      ((await _dio.get<List<dynamic>>('/v0/subjects/$id/subjects')).data ?? [])
          .map((row) => RelatedAnimeDto.fromJson(row as Map<String, dynamic>))
          .toList();

  Future<List<CharacterDto>> characters(int id) async =>
      ((await _dio.get<List<dynamic>>('/v0/subjects/$id/characters')).data ??
              [])
          .map((row) => CharacterDto.fromJson(row as Map<String, dynamic>))
          .toList();

  Future<({List<AnimeDto> items, int total})> browse(
    BrowseQuery query,
    int offset,
  ) async {
    final Map<String, dynamic> json;
    if (query.mode == BrowseMode.ranking) {
      json = (await _dio.get<Map<String, dynamic>>(
        '/v0/subjects',
        queryParameters: {
          'type': 2,
          'sort': 'rank',
          'limit': 24,
          'offset': offset,
          if (query.year > 0) 'year': query.year,
          if (query.format != BrowseFormat.all)
            'cat': switch (query.format) {
              BrowseFormat.tv => 1,
              BrowseFormat.ova => 2,
              BrowseFormat.movie => 3,
              BrowseFormat.web => 5,
              BrowseFormat.all => throw StateError(
                'All formats have no category',
              ),
            },
        },
      )).data!;
    } else {
      if (query.year < 1900 || query.quarter < 1 || query.quarter > 4) {
        throw ArgumentError('Invalid season');
      }
      final start = DateTime.utc(query.year, (query.quarter - 1) * 3 + 1);
      final end = DateTime.utc(query.year, query.quarter * 3 + 1);
      String date(DateTime value) =>
          '${value.year}-${value.month.toString().padLeft(2, '0')}-01';
      json = (await _dio.post<Map<String, dynamic>>(
        '/v0/search/subjects',
        queryParameters: {'limit': 24, 'offset': offset},
        data: {
          'keyword': '',
          'sort': query.order.name,
          'filter': {
            'type': [2],
            'nsfw': false,
            'air_date': ['>=${date(start)}', '<${date(end)}'],
            if (query.format != BrowseFormat.all)
              'tag': [
                switch (query.format) {
                  BrowseFormat.tv => 'TV',
                  BrowseFormat.movie => '剧场版',
                  BrowseFormat.ova => 'OVA',
                  BrowseFormat.web => 'WEB',
                  BrowseFormat.all => throw StateError(
                    'All formats have no tag',
                  ),
                },
              ],
          },
        },
      )).data!;
    }
    return (
      items: (json['data'] as List<dynamic>)
          .map((row) => AnimeDto.fromJson(row as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Future<List<AnimeDto>> calendar() async {
    final response = await _dio.get<List<dynamic>>('/calendar');
    final seen = <int>{};
    final result = <AnimeDto>[];
    for (final day in response.data ?? []) {
      for (final item
          in (day as Map<String, dynamic>)['items'] as List<dynamic>) {
        final dto = AnimeDto.fromJson(item as Map<String, dynamic>);
        if (seen.add(dto.id)) result.add(dto);
      }
    }
    return result;
  }

  Future<({List<AnimeDto> items, int total})> search(
    String keyword,
    int offset, {
    AnimeFilter? filter,
  }) async {
    final tags = <String>[
      if (filter != null) ...[
        switch (filter.region) {
          AnimeRegion.all => '',
          AnimeRegion.japan => '日本',
          AnimeRegion.china => '中国',
          AnimeRegion.western => '欧美',
        },
        switch (filter.format) {
          AnimeFormat.all => '',
          AnimeFormat.tv => 'TV',
          AnimeFormat.movie => '剧场版',
          AnimeFormat.ova => 'OVA',
          AnimeFormat.web => 'WEB',
        },
        ?filter.genre,
      ],
    ]..removeWhere((tag) => tag.isEmpty);
    final response = await _dio.post<Map<String, dynamic>>(
      '/v0/search/subjects',
      queryParameters: {'limit': 24, 'offset': offset},
      data: {
        'keyword': keyword,
        'sort': filter?.sort.name ?? (keyword.isEmpty ? 'rank' : 'match'),
        'filter': {
          'type': [2],
          'nsfw': false,
          if (tags.isNotEmpty) 'tag': tags,
          if (filter != null && filter.year != 0)
            'air_date': filter.year == -1
                ? ['<2000-01-01']
                : ['>=${filter.year}-01-01', '<${filter.year + 1}-01-01'],
        },
      },
    );
    final json = response.data!;
    return (
      items: (json['data'] as List<dynamic>)
          .map((e) => AnimeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Future<AnimeDto> subject(int id) async => AnimeDto.fromJson(
    (await _dio.get<Map<String, dynamic>>('/v0/subjects/$id')).data!,
  );
  Future<List<EpisodeDto>> episodes(int id) async {
    final result = <EpisodeDto>[];
    var offset = 0;
    for (var page = 0; page < 25; page++) {
      final json = (await _dio.get<Map<String, dynamic>>(
        '/v0/episodes',
        queryParameters: {'subject_id': id, 'limit': 100, 'offset': offset},
      )).data!;
      final rows = (json['data'] as List<dynamic>)
          .map((e) => EpisodeDto.fromJson(e as Map<String, dynamic>))
          .toList();
      result.addAll(rows);
      offset += rows.length;
      if (rows.isEmpty || offset >= (json['total'] as int)) return result;
    }
    throw const FormatException('章节数量超过当前支持范围');
  }
}
