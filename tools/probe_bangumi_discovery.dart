import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mamba_tv/data/repositories/bangumi_discovery_repository.dart';
import 'package:mamba_tv/data/services/bangumi_service.dart';
import 'package:mamba_tv/domain/bangumi_discovery.dart';
import 'package:mamba_tv/domain/models.dart';

Future<void> main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.bgm.tv',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'User-Agent': 'Mamba-Animation-TV/0.1 (Bangumi discovery verification)',
      },
    ),
  );
  try {
    final repository = RemoteBangumiDiscoveryRepository(BangumiService(dio));
    final results = await Future.wait<Object>([
      repository.calendar(),
      repository.relations(400602),
      repository.characters(400602),
      repository.browse(const BrowseQuery(year: 2026, quarter: 4)),
      repository.browse(const BrowseQuery(mode: BrowseMode.ranking)),
    ]);
    final days = results[0] as List<BroadcastDay>;
    final relations = results[1] as List<RelatedAnime>;
    final cast = results[2] as List<AnimeCharacter>;
    final season = results[3] as AnimePage;
    final ranking = results[4] as AnimePage;
    if (days.length != 7 ||
        relations.isEmpty ||
        cast.isEmpty ||
        season.items.isEmpty ||
        ranking.items.isEmpty) {
      throw StateError('Expected live discovery data');
    }
    for (final anime in season.items) {
      final date = DateTime.parse(anime.date);
      if (date.isBefore(DateTime(2026, 10)) ||
          !date.isBefore(DateTime(2027, 1))) {
        throw StateError('Season outside query');
      }
    }
    stdout.writeln(
      jsonEncode({
        'mode': 'live-bangumi-discovery',
        'weekdays': days.length,
        'calendarItems': days.fold(0, (sum, day) => sum + day.items.length),
        'relatedAnime': relations.length,
        'characters': cast.length,
        'voiceActors': cast.fold(0, (sum, role) => sum + role.actors.length),
        'seasonTotal': season.total,
        'seasonPage': season.items.length,
        'rankingTotal': ranking.total,
        'rankingPage': ranking.items.length,
      }),
    );
  } catch (error) {
    stderr.writeln(
      'Bangumi discovery live probe failed (${error.runtimeType}).',
    );
    exitCode = 1;
  } finally {
    dio.close(force: true);
  }
}
