import 'package:dio/dio.dart';

import '../../domain/failure.dart';
import '../../domain/anime_filter.dart';
import '../../domain/models.dart';
import '../../domain/repositories.dart';
import '../services/bangumi_service.dart';

class BangumiRepository implements CatalogRepository {
  const BangumiRepository(this._service);
  final BangumiService _service;
  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      throw AppFailure(
        status == 404
            ? '没有找到这个条目'
            : status == 429
            ? '请求较频繁，请稍后重试'
            : '暂时无法连接 Bangumi，请检查网络后重试',
      );
    } catch (_) {
      throw const AppFailure('番剧资料格式暂时无法读取，请稍后重试');
    }
  }

  @override
  Future<DiscoveryFeed> discover() => _request(() async {
    final results = await Future.wait([
      _service.calendar(),
      _service.search('', 0).then((value) => value.items),
    ]);
    final airing = results[0].map((e) => e.toEntity()).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return DiscoveryFeed(
      airing: List.unmodifiable(airing),
      popular: List.unmodifiable(results[1].map((e) => e.toEntity())),
    );
  });

  @override
  Future<AnimePage> search(
    String keyword, {
    int offset = 0,
    AnimeFilter? filter,
  }) => _request(() async {
    final page = await _service.search(keyword, offset, filter: filter);
    return AnimePage(
      List.unmodifiable(page.items.map((e) => e.toEntity())),
      page.total,
    );
  });

  @override
  Future<Anime> getAnime(int id) =>
      _request(() async => (await _service.subject(id)).toEntity());
  @override
  Future<List<Episode>> getEpisodes(int subjectId) => _request(() async {
    final episodes =
        (await _service.episodes(subjectId))
            .map((e) => e.toEntity(subjectId))
            .toList()
          ..sort(
            (a, b) => a.type != b.type
                ? a.type.compareTo(b.type)
                : a.sort.compareTo(b.sort),
          );
    return List.unmodifiable(episodes);
  });
}
