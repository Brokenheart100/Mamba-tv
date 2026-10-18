// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bangumi_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeDto _$AnimeDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AnimeDto',
  json,
  ($checkedConvert) {
    final val = AnimeDto(
      id: $checkedConvert('id', (v) => (v as num).toInt()),
      name: $checkedConvert('name', (v) => v as String? ?? ''),
      nameCn: $checkedConvert('name_cn', (v) => v as String? ?? ''),
      summary: $checkedConvert('summary', (v) => v as String? ?? ''),
      date: $checkedConvert('date', (v) => v as String? ?? ''),
      airDate: $checkedConvert('air_date', (v) => v as String? ?? ''),
      eps: $checkedConvert('eps', (v) => (v as num?)?.toInt() ?? 0),
      totalEpisodes: $checkedConvert(
        'total_episodes',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      images: $checkedConvert(
        'images',
        (v) => v == null ? null : ImagesDto.fromJson(v as Map<String, dynamic>),
      ),
      rating: $checkedConvert(
        'rating',
        (v) => v == null ? null : RatingDto.fromJson(v as Map<String, dynamic>),
      ),
      tags: $checkedConvert(
        'tags',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'nameCn': 'name_cn',
    'airDate': 'air_date',
    'totalEpisodes': 'total_episodes',
  },
);

Map<String, dynamic> _$AnimeDtoToJson(AnimeDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_cn': instance.nameCn,
  'summary': instance.summary,
  'date': instance.date,
  'air_date': instance.airDate,
  'eps': instance.eps,
  'total_episodes': instance.totalEpisodes,
  'images': instance.images?.toJson(),
  'rating': instance.rating?.toJson(),
  'tags': instance.tags.map((e) => e.toJson()).toList(),
};

ImagesDto _$ImagesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ImagesDto', json, ($checkedConvert) {
      final val = ImagesDto(
        large: $checkedConvert('large', (v) => v as String?),
        common: $checkedConvert('common', (v) => v as String?),
        medium: $checkedConvert('medium', (v) => v as String?),
        small: $checkedConvert('small', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ImagesDtoToJson(ImagesDto instance) => <String, dynamic>{
  'large': instance.large,
  'common': instance.common,
  'medium': instance.medium,
  'small': instance.small,
};

RatingDto _$RatingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RatingDto', json, ($checkedConvert) {
      final val = RatingDto(
        score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$RatingDtoToJson(RatingDto instance) => <String, dynamic>{
  'score': instance.score,
};

TagDto _$TagDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TagDto', json, ($checkedConvert) {
      final val = TagDto(name: $checkedConvert('name', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$TagDtoToJson(TagDto instance) => <String, dynamic>{
  'name': instance.name,
};

EpisodeDto _$EpisodeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EpisodeDto', json, ($checkedConvert) {
      final val = EpisodeDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        nameCn: $checkedConvert('name_cn', (v) => v as String? ?? ''),
        sort: $checkedConvert('sort', (v) => (v as num).toDouble()),
        type: $checkedConvert('type', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    }, fieldKeyMap: const {'nameCn': 'name_cn'});

Map<String, dynamic> _$EpisodeDtoToJson(EpisodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_cn': instance.nameCn,
      'sort': instance.sort,
      'type': instance.type,
    };
