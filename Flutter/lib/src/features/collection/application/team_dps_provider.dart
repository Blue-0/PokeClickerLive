import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../pokemon/application/pokemon_provider.dart';
import 'collection_controller.dart';
import 'team_controller.dart';

part 'team_dps_provider.g.dart';

@riverpod
Future<int> teamDps(Ref ref) async {
  final teamState = ref.watch(teamControllerProvider);
  final collectionState = ref.watch(collectionControllerProvider);

  int totalAttack = 0;

  // Create a list of futures for each pokemon in the team
  final futures = teamState.activePokemonIds.map((id) {
    try {
      final userPokemon = collectionState.ownedPokemon.firstWhere(
        (p) => p.id == id,
      );
      return ref.watch(pokemonDetailsProvider(userPokemon.pokemonId).future);
    } catch (_) {
      return Future.value(null);
    }
  }).toList();

  final pokemons = await Future.wait(futures);

  for (final pokemon in pokemons) {
    if (pokemon != null) {
      totalAttack += pokemon.attack;
    }
  }

  return (totalAttack / 10).floor();
}
