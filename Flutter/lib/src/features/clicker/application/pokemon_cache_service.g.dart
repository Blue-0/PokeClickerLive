// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One-line provider to expose the manager.
/// Kept alive to persist the cache instance.

@ProviderFor(pokemonCacheManager)
final pokemonCacheManagerProvider = PokemonCacheManagerProvider._();

/// One-line provider to expose the manager.
/// Kept alive to persist the cache instance.

final class PokemonCacheManagerProvider
    extends $FunctionalProvider<CacheManager, CacheManager, CacheManager>
    with $Provider<CacheManager> {
  /// One-line provider to expose the manager.
  /// Kept alive to persist the cache instance.
  PokemonCacheManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pokemonCacheManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pokemonCacheManagerHash();

  @$internal
  @override
  $ProviderElement<CacheManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheManager create(Ref ref) {
    return pokemonCacheManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheManager>(value),
    );
  }
}

String _$pokemonCacheManagerHash() =>
    r'5d26b72d6dcb44bf6a1c353ddac420e7db83ba9e';
