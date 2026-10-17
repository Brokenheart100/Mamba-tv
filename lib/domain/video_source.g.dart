// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoSource _$VideoSourceFromJson(Map<String, dynamic> json) => _VideoSource(
  id: json['id'] as String,
  name: json['name'] as String,
  endpoint: json['endpoint'] as String,
  enabled: json['enabled'] as bool? ?? true,
  factoryId: json['factoryId'] as String? ?? 'maccms',
  arguments:
      json['arguments'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  subscriptionUrl: json['subscriptionUrl'] as String?,
  tier: (json['tier'] as num?)?.toInt() ?? 2,
);

Map<String, dynamic> _$VideoSourceToJson(_VideoSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'endpoint': instance.endpoint,
      'enabled': instance.enabled,
      'factoryId': instance.factoryId,
      'arguments': instance.arguments,
      'subscriptionUrl': instance.subscriptionUrl,
      'tier': instance.tier,
    };
