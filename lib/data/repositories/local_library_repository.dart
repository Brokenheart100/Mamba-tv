import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';
import '../database/app_database.dart';
import '../services/bangumi_dto.dart';

class LocalLibraryRepository implements LibraryRepository {
  const LocalLibraryRepository(this._db);
  final AppDatabase _db;
  Anime _anime(String json) =>
      AnimeDto.fromJson(jsonDecode(json) as Map<String, dynamic>).toEntity();
  String _json(Anime anime) => jsonEncode(AnimeDto.fromEntity(anime).toJson());
  WatchProgress _progress(WatchRecord row) => WatchProgress(
    anime: _anime(row.animeJson),
    episode: Episode(
      id: row.episodeId,
      subjectId: row.subjectId,
      title: row.episodeTitle,
      sort: row.episodeSort,
      type: row.episodeType,
    ),
    position: Duration(milliseconds: row.positionMs),
    duration: Duration(milliseconds: row.durationMs),
    updatedAt: row.updatedAt,
  );
  @override
  Stream<List<Anime>> watchFavorites() =>
      (_db.select(_db.favorites)
            ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
          .watch()
          .map((rows) => rows.map((row) => _anime(row.animeJson)).toList());
  @override
  Stream<List<WatchProgress>> watchHistory() =>
      (_db.select(_db.watchRecords)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch()
          .map((rows) => rows.map(_progress).toList());
  @override
  Future<bool> isFavorite(int subjectId) async =>
      (await (_db.select(
        _db.favorites,
      )..where((t) => t.subjectId.equals(subjectId))).getSingleOrNull()) !=
      null;
  @override
  Future<void> setFavorite(Anime anime, bool value) async {
    if (value) {
      await _db
          .into(_db.favorites)
          .insertOnConflictUpdate(
            FavoritesCompanion.insert(
              subjectId: Value(anime.id),
              animeJson: _json(anime),
              addedAt: DateTime.now(),
            ),
          );
    } else {
      await (_db.delete(
        _db.favorites,
      )..where((t) => t.subjectId.equals(anime.id))).go();
    }
  }

  @override
  Future<WatchProgress?> getProgress(int episodeId) async {
    final row = await (_db.select(
      _db.watchRecords,
    )..where((t) => t.episodeId.equals(episodeId))).getSingleOrNull();
    return row == null ? null : _progress(row);
  }

  @override
  Future<void> saveProgress(WatchProgress p) async {
    await _db
        .into(_db.watchRecords)
        .insertOnConflictUpdate(
          WatchRecordsCompanion.insert(
            episodeId: Value(p.episode.id),
            subjectId: p.anime.id,
            animeJson: _json(p.anime),
            episodeTitle: p.episode.title,
            episodeSort: p.episode.sort,
            episodeType: p.episode.type,
            positionMs: p.position.inMilliseconds,
            durationMs: p.duration.inMilliseconds,
            updatedAt: p.updatedAt,
          ),
        );
  }

  @override
  Future<void> deleteProgress(int episodeId) async {
    await (_db.delete(
      _db.watchRecords,
    )..where((t) => t.episodeId.equals(episodeId))).go();
  }

  @override
  Future<PlayableMedia?> getMedia(int episodeId) async {
    final row = await (_db.select(
      _db.mediaBindings,
    )..where((t) => t.episodeId.equals(episodeId))).getSingleOrNull();
    return row == null
        ? null
        : PlayableMedia(
            Uri.parse(row.uri),
            headers: Map<String, String>.from(
              jsonDecode(row.headersJson) as Map,
            ),
            binding: row.sourceBindingJson == null
                ? null
                : MediaSourceBinding.fromJson(
                    jsonDecode(row.sourceBindingJson!) as Map<String, dynamic>,
                  ),
          );
  }

  @override
  Future<void> bindMedia(int episodeId, PlayableMedia media) async {
    await _db
        .into(_db.mediaBindings)
        .insertOnConflictUpdate(
          MediaBindingsCompanion.insert(
            episodeId: Value(episodeId),
            uri: media.uri.toString(),
            headersJson: Value(jsonEncode(media.headers)),
            sourceBindingJson: Value(
              media.binding == null
                  ? null
                  : jsonEncode(media.binding!.toJson()),
            ),
          ),
        );
  }
}
