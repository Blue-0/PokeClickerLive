import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_pokemon.dart';

part 'collection_repository.g.dart';

/// Provider for the collection repository
@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(Ref ref) {
  // We assume the box is already opened in main/bootstrap
  final box = Hive.box<UserPokemon>('user_pokemon');
  return CollectionRepository(box);
}

class CollectionRepository {
  final Box<UserPokemon> _box;

  CollectionRepository(this._box);

  /// Add a Pokémon to the collection
  Future<void> addPokemon(UserPokemon pokemon) async {
    await _box.put(pokemon.id, pokemon);
  }

  /// Get all captured Pokémon
  List<UserPokemon> getAllPokemon() {
    return _box.values.toList();
  }

  /// Returns true if the box already contains an entry for [pokemonId].
  bool hasPokemonId(int pokemonId) {
    return _box.values.any((p) => p.pokemonId == pokemonId);
  }

  /// Remove all Pokémon from the local Hive box.
  /// Called before restoring from the cloud to avoid stale/duplicate entries.
  Future<void> clearAll() async {
    await _box.clear();
  }
}
