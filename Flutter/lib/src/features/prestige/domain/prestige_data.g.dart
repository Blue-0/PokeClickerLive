// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestige_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrestigeData _$PrestigeDataFromJson(Map<String, dynamic> json) =>
    _PrestigeData(
      prestigeLevel: (json['prestigeLevel'] as num?)?.toInt() ?? 0,
      badgesAmount: (json['badgesAmount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PrestigeDataToJson(_PrestigeData instance) =>
    <String, dynamic>{
      'prestigeLevel': instance.prestigeLevel,
      'badgesAmount': instance.badgesAmount,
    };
