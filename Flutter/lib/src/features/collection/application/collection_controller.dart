import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../data/collection_repository.dart';
import '../domain/collection_state.dart';
import '../domain/user_pokemon.dart';
import 'capture_service.dart';

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
}
