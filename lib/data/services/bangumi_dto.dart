import 'package:json_annotation/json_annotation.dart';

import '../../domain/models.dart';
part 'bangumi_dto.g.dart';

@JsonSerializable(checked: true, explicitToJson: true)
class AnimeDto {
  const AnimeDto({
    required this.id,
    this.name = '',
    this.nameCn = '',
    this.summary = '',
    this.date = '',
    this.airDate = '',
    this.eps = 0,
    this.totalEpisodes = 0,
    this.images,
    this.rating,
    this.tags = const [],
  });
  factory AnimeDto.fromJson(Map<String, dynamic> json) =>
      _$AnimeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AnimeDtoToJson(this);
  final int id;
  final String name;
  @JsonKey(name: 'name_cn', defaultValue: '')
  final String nameCn;
  final String summary;
  final String date;
  @JsonKey(name: 'air_date', defaultValue: '')
  final String airDate;
  final int eps;
  @JsonKey(name: 'total_episodes', defaultValue: 0)
  final int totalEpisodes;
  final ImagesDto? images;
  final RatingDto? rating;
  final List<TagDto> tags;
  Anime toEntity() => Anime(
    id: id,
    title: nameCn.isNotEmpty
        ? nameCn
        : name.isNotEmpty
        ? name
        : '未命名番剧',
    originalTitle: name,
    summary: summary,
    image: (images?.large ?? images?.common ?? '').replaceFirst(
      RegExp(r'^http:'),
      'https:',
    ),
    date: date.isNotEmpty ? date : airDate,
    score: rating?.score ?? 0,
    episodeCount: eps > 0 ? eps : totalEpisodes,
    tags: tags.take(8).map((e) => e.name).toList(),
  );
  factory AnimeDto.fromEntity(Anime anime) => AnimeDto(
    id: anime.id,
    name: anime.originalTitle,
    nameCn: anime.title,
    summary: anime.summary,
    date: anime.date,
    eps: anime.episodeCount,
    images: ImagesDto(large: anime.image),
    rating: RatingDto(score: anime.score),
    tags: anime.tags.map((e) => TagDto(name: e)).toList(),
  );
}

@JsonSerializable(checked: true)
class ImagesDto {
  const ImagesDto({this.large, this.common});
  factory ImagesDto.fromJson(Map<String, dynamic> json) =>
      _$ImagesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesDtoToJson(this);
  final String? large;
  final String? common;
}

@JsonSerializable(checked: true)
class RatingDto {
  const RatingDto({this.score = 0});
  factory RatingDto.fromJson(Map<String, dynamic> json) =>
      _$RatingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RatingDtoToJson(this);
  final double score;
}

@JsonSerializable(checked: true)
class TagDto {
  const TagDto({required this.name});
  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TagDtoToJson(this);
  final String name;
}

@JsonSerializable(checked: true)
class EpisodeDto {
  const EpisodeDto({
    required this.id,
    this.name = '',
    this.nameCn = '',
    required this.sort,
    this.type = 0,
  });
  factory EpisodeDto.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeDtoToJson(this);
  final int id;
  final String name;
  @JsonKey(name: 'name_cn', defaultValue: '')
  final String nameCn;
  final double sort;
  final int type;
  Episode toEntity(int subjectId) => Episode(
    id: id,
    subjectId: subjectId,
    title: nameCn.isNotEmpty
        ? nameCn
        : name.isNotEmpty
        ? name
        : '第 $sort 集',
    sort: sort,
    type: type,
  );
}
