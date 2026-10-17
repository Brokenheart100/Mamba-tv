import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mamba_tv/data/services/bangumi_service.dart';
import 'package:mamba_tv/domain/anime_filter.dart';

Future<void> main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.bgm.tv',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'User-Agent': 'Mamba-Animation-TV/0.1 (Flutter; API verification)',
      },
    ),
  );
  try {
    final api = BangumiService(dio);
    final calendar = await api.calendar();
    final page = await api.search('葬送的芙莉莲', 0);
    if (page.items.isEmpty) throw StateError('No search results');
    final subject = await api.subject(page.items.first.id);
    final episodes = await api.episodes(subject.id);
    final popular = await api.search('', 0);
    const filter = AnimeFilter(
      region: AnimeRegion.china,
      genre: '奇幻',
      year: 2024,
      sort: AnimeSort.heat,
    );
    final category = await api.search('', 0, filter: filter);
    final categoryNext = await api.search(
      '',
      category.items.length,
      filter: filter,
    );
    if (category.items.isEmpty) throw StateError('No filtered results');
    for (final anime in [...category.items, ...categoryNext.items]) {
      final tags = anime.tags.map((tag) => tag.name).toSet();
      if (!tags.containsAll(['中国', '奇幻']) || !anime.date.startsWith('2024-')) {
        throw StateError('API returned an item outside the category query');
      }
    }
    if (category.items
        .map((anime) => anime.id)
        .toSet()
        .intersection(categoryNext.items.map((anime) => anime.id).toSet())
        .isNotEmpty) {
      throw StateError('Filtered pagination returned overlapping items');
    }
    stdout.writeln(
      jsonEncode({
        'calendarCount': calendar.length,
        'searchTotal': page.total,
        'subjectId': subject.id,
        'title': subject.toEntity().title,
        'episodeCount': episodes.length,
        'popularCount': popular.items.length,
        'categoryTotal': category.total,
        'categoryFirstPage': category.items.length,
        'categoryNextPage': categoryNext.items.length,
        'categoryExample': category.items.first.toEntity().title,
        'categoryFilter': '中国 + 奇幻 + 2024 / heat',
      }),
    );
  } catch (error) {
    stderr.writeln('Bangumi live probe failed: ${error.runtimeType}');
    exitCode = 1;
  } finally {
    dio.close(force: true);
  }
}
