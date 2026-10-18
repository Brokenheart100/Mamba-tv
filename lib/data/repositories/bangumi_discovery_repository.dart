import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/bangumi_discovery.dart';
import '../../domain/failure.dart';
import '../../domain/models.dart';
import '../services/bangumi_dto.dart';
import '../services/bangumi_service.dart';

class RemoteBangumiDiscoveryRepository implements BangumiDiscoveryRepository {
  const RemoteBangumiDiscoveryRepository(this._service);
  final BangumiService _service;

  Future<T> _request<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw AppFailure(
        error.response?.statusCode == 429
            ? '请求较频繁，请稍后重试'
            : '暂时无法连接 Bangumi，请稍后重试',
      );
    } on FormatException {
      throw const AppFailure('Bangumi 资料格式暂时无法读取');
    } on CheckedFromJsonException {
      throw const AppFailure('Bangumi 资料格式暂时无法读取');
    }
  }

  @override
  Future<List<BroadcastDay>> calendar() => _request(() async {
    final days = await _service.calendarDays();
    return List.unmodifiable(
      List.generate(7, (index) {
        final items = <int, Anime>{};
        for (final day in days.where((day) => day.weekday.id == index + 1)) {
          for (final anime in day.items) {
            items[anime.id] = anime.toEntity();
          }
        }
        return BroadcastDay(weekday: index + 1, items: items.values.toList());
      }),
    );
  });

  @override
  Future<AnimePage> browse(BrowseQuery query, {int offset = 0}) =>
      _request(() async {
        final page = await _service.browse(query, offset);
        return AnimePage(
          List.unmodifiable(page.items.map((item) => item.toEntity())),
          page.total,
        );
      });

  @override
  Future<List<RelatedAnime>> relations(int subjectId) => _request(() async {
    final rows = await _service.relations(subjectId);
    final seen = <int>{};
    return List.unmodifiable(
      rows
          .where(
            (row) =>
                row.type == 2 &&
                row.id != subjectId &&
                row.id > 0 &&
                seen.add(row.id),
          )
          .map(
            (row) => RelatedAnime(
              anime: AnimeDto(
                id: row.id,
                name: row.name,
                nameCn: row.nameCn,
                images: row.images,
              ).toEntity(),
              relation: row.relation,
            ),
          ),
    );
  });

  @override
  Future<List<AnimeCharacter>> characters(int subjectId) => _request(() async {
    final rows = await _service.characters(subjectId);
    final seen = <int>{};
    return List.unmodifiable(
      rows
          .where((row) => row.id > 0 && seen.add(row.id))
          .map(
            (row) => AnimeCharacter(
              id: row.id,
              name: row.name,
              relation: row.relation,
              image:
                  (row.images?.large ??
                          row.images?.medium ??
                          row.images?.small ??
                          '')
                      .replaceFirst(RegExp(r'^http:'), 'https:'),
              actors: row.actors
                  .where((actor) => actor.id > 0)
                  .map((actor) => VoiceActor(id: actor.id, name: actor.name))
                  .toList(),
            ),
          ),
    );
  });
}
