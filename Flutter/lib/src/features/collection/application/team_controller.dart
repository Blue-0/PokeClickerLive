import 'package:pokeclickerlive/src/features/collection/data/team_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/team_state.dart';

part 'team_controller.g.dart';

@riverpod
class TeamController extends _$TeamController {
  @override
  TeamState build() {
    final repo = ref.watch(teamRepositoryProvider);
    return TeamState(activePokemonIds: repo.getTeam());
  }

  void addToTeam(String pokemonId) {
    if (state.activePokemonIds.length >= 6) return;
    if (state.activePokemonIds.contains(pokemonId)) return;

    final newList = [...state.activePokemonIds, pokemonId];
    state = state.copyWith(activePokemonIds: newList);

    ref.read(teamRepositoryProvider).saveTeam(newList);
  }

  void removeFromTeam(String pokemonId) {
    final newList = state.activePokemonIds
        .where((id) => id != pokemonId)
        .toList();
    state = state.copyWith(activePokemonIds: newList);

    ref.read(teamRepositoryProvider).saveTeam(newList);
  }

  void swapSlots(int indexA, int indexB) {
    if (indexA < 0 || indexA >= state.activePokemonIds.length) return;
    if (indexB < 0 || indexB >= state.activePokemonIds.length) return;

    final newList = List<String>.from(state.activePokemonIds);
    final temp = newList[indexA];
    newList[indexA] = newList[indexB];
    newList[indexB] = temp;

    state = state.copyWith(activePokemonIds: newList);

    ref.read(teamRepositoryProvider).saveTeam(newList);
  }

  void restoreFromCloud(List<String> pokemonIds) {
    state = state.copyWith(activePokemonIds: pokemonIds);
    ref.read(teamRepositoryProvider).saveTeam(pokemonIds);
  }
}
