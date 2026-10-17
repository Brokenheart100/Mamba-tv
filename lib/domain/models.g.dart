// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaSourceBinding _$MediaSourceBindingFromJson(Map<String, dynamic> json) =>
    _MediaSourceBinding(
      sourceId: json['sourceId'] as String,
      label: json['label'] as String,
      address: json['address'] as String,
      needsResolution: json['needsResolution'] as bool? ?? true,
      context:
          (json['context'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$MediaSourceBindingToJson(_MediaSourceBinding instance) =>
    <String, dynamic>{
      'sourceId': instance.sourceId,
      'label': instance.label,
      'address': instance.address,
      'needsResolution': instance.needsResolution,
      'context': instance.context,
    };
