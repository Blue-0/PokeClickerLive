import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../data/collection_repository.dart';
import '../domain/collection_state.dart';
import '../domain/user_pokemon.dart';
import 'capture_service.dart';
import 'package:flutter/foundation.dart';
import '../../sync/data/cloud_save_repository.dart';

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

      // Immediately persist to server so capture is not lost if the app
      // closes before the next 60-second periodic sync.
      ref.read(cloudSaveRepositoryProvider).registerCapture(speciesId);
    } else {
      state = state.copyWith(lastCaptureResult: result);
    }
  }

  /// Clears the last capture result notification.
  void clearCaptureNotification() {
    state = state.copyWith(lastCaptureResult: null);
  }

  /// Restores Pokemon collection from a cloud save snapshot.
  /// Clears the local Hive box first to avoid stale/duplicate entries from
  /// previous sessions. Each entry in [pokemonList] is a DB row with a
  /// 'pokemon_id' field.
  Future<void> restoreFromCloud(List<dynamic> pokemonList) async {
    final repo = ref.read(collectionRepositoryProvider);

    // Clear local storage first to prevent duplicates across login sessions
    await repo.clearAll();

    final restoredPokemon = <UserPokemon>[];

    for (final entry in pokemonList) {
      int? pokemonId;
      if (entry is Map) {
        pokemonId = ((entry['pokemon_id'] ?? entry['pokemonId']) as num?)?.toInt();
      }
      if (pokemonId == null) continue;

      // Skip if already restored in this batch (dedup within the server list)
      if (restoredPokemon.any((p) => p.pokemonId == pokemonId)) continue;

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
