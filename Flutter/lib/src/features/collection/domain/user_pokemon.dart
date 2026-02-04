import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_pokemon.freezed.dart';
part 'user_pokemon.g.dart';

@freezed
abstract class UserPokemon with _$UserPokemon {
  const factory UserPokemon({
    required String id,
    required int pokemonId,
    required DateTime acquiredAt,
  }) = _UserPokemon;

  factory UserPokemon.fromJson(Map<String, dynamic> json) =>
      _$UserPokemonFromJson(json);
}
