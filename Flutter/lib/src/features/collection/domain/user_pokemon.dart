import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_pokemon.freezed.dart';

@freezed
abstract class UserPokemon with _$UserPokemon {
  const factory UserPokemon({
    required String id,
    required int pokemonId,
    required DateTime acquiredAt,
  }) = _UserPokemon;
}
