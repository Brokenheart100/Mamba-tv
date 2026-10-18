import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'bangumi_discovery.freezed.dart';

enum BrowseMode { season, ranking }

enum BrowseOrder { heat, rank, score }

enum BrowseFormat { all, tv, movie, ova, web }

@freezed
abstract class BrowseQuery with _$BrowseQuery {
  const factory BrowseQuery({
    @Default(BrowseMode.season) BrowseMode mode,
    @Default(0) int year,
    @Default(1) int quarter,
    @Default(BrowseOrder.heat) BrowseOrder order,
    @Default(BrowseFormat.all) BrowseFormat format,
  }) = _BrowseQuery;
}

@freezed
abstract class BroadcastDay with _$BroadcastDay {
  const factory BroadcastDay({
    required int weekday,
    @Default([]) List<Anime> items,
  }) = _BroadcastDay;
}

@freezed
abstract class RelatedAnime with _$RelatedAnime {
  const factory RelatedAnime({required Anime anime, required String relation}) =
      _RelatedAnime;
}

@freezed
abstract class VoiceActor with _$VoiceActor {
  const factory VoiceActor({required int id, required String name}) =
      _VoiceActor;
}

@freezed
abstract class AnimeCharacter with _$AnimeCharacter {
  const factory AnimeCharacter({
    required int id,
    required String name,
    @Default('') String image,
    @Default('') String relation,
    @Default([]) List<VoiceActor> actors,
  }) = _AnimeCharacter;
}

abstract interface class BangumiDiscoveryRepository {
  Future<List<BroadcastDay>> calendar();
  Future<AnimePage> browse(BrowseQuery query, {int offset = 0});
  Future<List<RelatedAnime>> relations(int subjectId);
  Future<List<AnimeCharacter>> characters(int subjectId);
}
