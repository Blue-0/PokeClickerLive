import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeclickerlive/src/features/pokemon/data/pokemon_repository.dart';
import 'package:pokeclickerlive/src/features/pokemon/domain/pokemon.dart';

part 'pokemon_provider.g.dart';

@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  return PokemonRepository();
}

@riverpod
Future<Pokemon?> randomPokemon(Ref ref) async {
  final repo = ref.watch(pokemonRepositoryProvider);
  final result = await repo.getRandomSinnohPokemon();
  return result.fold((failure) => null, (pokemon) => pokemon);
}
