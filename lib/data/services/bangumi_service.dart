import 'package:dio/dio.dart';

import '../../domain/anime_filter.dart';
import 'bangumi_dto.dart';

class BangumiService {
  const BangumiService(this._dio);
  final Dio _dio;
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
