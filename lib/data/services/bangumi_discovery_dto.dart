import 'package:json_annotation/json_annotation.dart';

import 'bangumi_dto.dart';

part 'bangumi_discovery_dto.g.dart';

@JsonSerializable(checked: true, createToJson: false)
class CalendarDayDto {
  const CalendarDayDto({required this.weekday, this.items = const []});
  factory CalendarDayDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayDtoFromJson(json);
  final WeekdayDto weekday;
  final List<AnimeDto> items;
}

@JsonSerializable(checked: true, createToJson: false)
class WeekdayDto {
  const WeekdayDto({required this.id});
  factory WeekdayDto.fromJson(Map<String, dynamic> json) =>
      _$WeekdayDtoFromJson(json);
  final int id;
}

@JsonSerializable(checked: true, createToJson: false)
class RelatedAnimeDto {
  const RelatedAnimeDto({
    required this.id,
    required this.type,
    this.name = '',
    this.nameCn = '',
    this.relation = '',
    this.images,
  });
  factory RelatedAnimeDto.fromJson(Map<String, dynamic> json) =>
      _$RelatedAnimeDtoFromJson(json);
  final int id;
  final int type;
  final String name;
  @JsonKey(name: 'name_cn', defaultValue: '')
  final String nameCn;
  final String relation;
  final ImagesDto? images;
}

@JsonSerializable(checked: true, createToJson: false)
class CharacterDto {
  const CharacterDto({
    required this.id,
    this.name = '',
    this.relation = '',
    this.images,
    this.actors = const [],
  });
  factory CharacterDto.fromJson(Map<String, dynamic> json) =>
      _$CharacterDtoFromJson(json);
  final int id;
  final String name;
  final String relation;
  final ImagesDto? images;
  final List<ActorDto> actors;
}

@JsonSerializable(checked: true, createToJson: false)
class ActorDto {
  const ActorDto({required this.id, this.name = ''});
  factory ActorDto.fromJson(Map<String, dynamic> json) =>
      _$ActorDtoFromJson(json);
  final int id;
  final String name;
}
