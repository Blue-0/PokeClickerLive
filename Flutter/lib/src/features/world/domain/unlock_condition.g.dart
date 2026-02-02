// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlock_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnlockCondition _$UnlockConditionFromJson(Map<String, dynamic> json) =>
    _UnlockCondition(
      killCount: (json['killCount'] as num).toInt(),
      sourceZoneId: json['sourceZoneId'] as String,
    );

Map<String, dynamic> _$UnlockConditionToJson(_UnlockCondition instance) =>
    <String, dynamic>{
      'killCount': instance.killCount,
      'sourceZoneId': instance.sourceZoneId,
    };
