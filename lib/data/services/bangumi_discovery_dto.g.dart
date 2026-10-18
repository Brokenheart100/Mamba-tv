// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bangumi_discovery_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarDayDto _$CalendarDayDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CalendarDayDto', json, ($checkedConvert) {
      final val = CalendarDayDto(
        weekday: $checkedConvert(
          'weekday',
          (v) => WeekdayDto.fromJson(v as Map<String, dynamic>),
        ),
        items: $checkedConvert(
          'items',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => AnimeDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

WeekdayDto _$WeekdayDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WeekdayDto', json, ($checkedConvert) {
      final val = WeekdayDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
      );
      return val;
    });

RelatedAnimeDto _$RelatedAnimeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RelatedAnimeDto', json, ($checkedConvert) {
      final val = RelatedAnimeDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        type: $checkedConvert('type', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        nameCn: $checkedConvert('name_cn', (v) => v as String? ?? ''),
        relation: $checkedConvert('relation', (v) => v as String? ?? ''),
        images: $checkedConvert(
          'images',
          (v) =>
              v == null ? null : ImagesDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'nameCn': 'name_cn'});

CharacterDto _$CharacterDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CharacterDto', json, ($checkedConvert) {
      final val = CharacterDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        relation: $checkedConvert('relation', (v) => v as String? ?? ''),
        images: $checkedConvert(
          'images',
          (v) =>
              v == null ? null : ImagesDto.fromJson(v as Map<String, dynamic>),
        ),
        actors: $checkedConvert(
          'actors',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => ActorDto.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

ActorDto _$ActorDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ActorDto', json, ($checkedConvert) {
      final val = ActorDto(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
      );
      return val;
    });
