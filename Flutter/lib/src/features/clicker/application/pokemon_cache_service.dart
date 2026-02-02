import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_cache_service.g.dart';

/// One-line provider to expose the manager.
/// Kept alive to persist the cache instance.
@Riverpod(keepAlive: true)
CacheManager pokemonCacheManager(Ref ref) {
  return PokemonCacheManager();
}

/// A custom CacheManager for Pokémon sprites.
class PokemonCacheManager extends CacheManager {
  static const key = 'pokemonCache';

  static final PokemonCacheManager _instance = PokemonCacheManager._();

  factory PokemonCacheManager() {
    return _instance;
  }

  PokemonCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 2000,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
}
