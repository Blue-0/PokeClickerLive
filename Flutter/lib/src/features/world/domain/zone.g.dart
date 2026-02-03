// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Zone _$ZoneFromJson(Map<String, dynamic> json) => _Zone(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$ZoneTypeEnumMap, json['type']),
  isUnlocked: json['isUnlocked'] as bool? ?? false,
  unlockCondition: json['unlockCondition'] == null
      ? null
      : UnlockCondition.fromJson(
          json['unlockCondition'] as Map<String, dynamic>,
        ),
  pokemonIds:
      (json['pokemonIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  bossPokemonId: (json['bossPokemonId'] as num?)?.toInt(),
  bossTimerSeconds: (json['bossTimerSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$ZoneToJson(_Zone instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$ZoneTypeEnumMap[instance.type]!,
  'isUnlocked': instance.isUnlocked,
  'unlockCondition': instance.unlockCondition,
  'pokemonIds': instance.pokemonIds,
  'bossPokemonId': instance.bossPokemonId,
  'bossTimerSeconds': instance.bossTimerSeconds,
};

const _$ZoneTypeEnumMap = {
  ZoneType.route: 'route',
  ZoneType.town: 'town',
  ZoneType.dungeon: 'dungeon',
};
