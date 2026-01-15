// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pokemon _$PokemonFromJson(Map<String, dynamic> json) => _Pokemon(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  spriteUrl: json['spriteUrl'] as String,
  hp: (json['hp'] as num?)?.toInt() ?? 50,
  attack: (json['attack'] as num?)?.toInt() ?? 50,
);

Map<String, dynamic> _$PokemonToJson(_Pokemon instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'spriteUrl': instance.spriteUrl,
  'hp': instance.hp,
  'attack': instance.attack,
};
