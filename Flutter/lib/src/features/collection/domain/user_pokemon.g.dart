// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPokemon _$UserPokemonFromJson(Map<String, dynamic> json) => _UserPokemon(
  id: json['id'] as String,
  pokemonId: (json['pokemonId'] as num).toInt(),
  acquiredAt: DateTime.parse(json['acquiredAt'] as String),
);

Map<String, dynamic> _$UserPokemonToJson(_UserPokemon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pokemonId': instance.pokemonId,
      'acquiredAt': instance.acquiredAt.toIso8601String(),
    };
