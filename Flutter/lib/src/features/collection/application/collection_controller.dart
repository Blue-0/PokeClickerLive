import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../data/collection_repository.dart';
import '../domain/collection_state.dart';
import '../domain/user_pokemon.dart';
import 'capture_service.dart';
import 'package:flutter/foundation.dart';

part 'collection_controller.g.dart';

@Riverpod(keepAlive: true)
class CollectionController extends _$CollectionController {
  @override
  CollectionState build() {
    return _loadInitialData();
  }

  CollectionState _loadInitialData() {
    final repo = ref.watch(collectionRepositoryProvider);
    final pokemon = repo.getAllPokemon();
    return CollectionState(ownedPokemon: pokemon);
  }

  /// Records a capture attempt and updates state/persistence if successful.
  Future<void> recordCaptureAttempt(int speciesId, CaptureResult result) async {
    if (result == CaptureResult.success) {
      final repo = ref.read(collectionRepositoryProvider);

      final newPokemon = UserPokemon(
        id: const Uuid().v4(),
        pokemonId: speciesId,
        acquiredAt: DateTime.now(),
      );

      await repo.addPokemon(newPokemon);

      state = state.copyWith(
        ownedPokemon: [...state.ownedPokemon, newPokemon],
        lastCaptureResult: result,
      );
    } else {
      state = state.copyWith(lastCaptureResult: result);
    }

    // Reset result after a short delay to allow UI listeners to trigger correctly if the same result happens twice
    // (Actually Riverpod listeners trigger on state change, so if we want to show it again we might need a reset)
    // For now, we'll just keep it and the UI will check for changes.
  }

  /// Clears the last capture result notification.
  void clearCaptureNotification() {
    state = state.copyWith(lastCaptureResult: null);
  }

  /// Restores Pokemon collection from a cloud save snapshot.
  /// Each entry in [pokemonList] is a DB row with a 'pokemon_id' field.
  Future<void> restoreFromCloud(List<dynamic> pokemonList) async {
    final repo = ref.read(collectionRepositoryProvider);
    final restoredPokemon = <UserPokemon>[];

    for (final entry in pokemonList) {
      int? pokemonId;
      if (entry is Map) {
        pokemonId = ((entry['pokemon_id'] ?? entry['pokemonId']) as num?)?.toInt();
      }
      if (pokemonId == null) continue;

      final up = UserPokemon(
        id: const Uuid().v4(),
        pokemonId: pokemonId,
        acquiredAt: DateTime.now(),
      );
      try {
        await repo.addPokemon(up);
        restoredPokemon.add(up);
      } catch (e) {
        debugPrint('CollectionController.restoreFromCloud: failed to add pokemon $pokemonId: $e');
      }
    }

    state = state.copyWith(ownedPokemon: restoredPokemon);
  }
}
