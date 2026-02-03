// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pokemonRepository)
final pokemonRepositoryProvider = PokemonRepositoryProvider._();

final class PokemonRepositoryProvider
    extends
        $FunctionalProvider<
          PokemonRepository,
          PokemonRepository,
          PokemonRepository
        >
    with $Provider<PokemonRepository> {
  PokemonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pokemonRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pokemonRepositoryHash();

  @$internal
  @override
  $ProviderElement<PokemonRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PokemonRepository create(Ref ref) {
    return pokemonRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PokemonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PokemonRepository>(value),
    );
  }
}

String _$pokemonRepositoryHash() => r'6bda524134fb341354f3c8a33428343e6f951e50';

@ProviderFor(randomPokemon)
final randomPokemonProvider = RandomPokemonProvider._();

final class RandomPokemonProvider
    extends
        $FunctionalProvider<AsyncValue<Pokemon?>, Pokemon?, FutureOr<Pokemon?>>
    with $FutureModifier<Pokemon?>, $FutureProvider<Pokemon?> {
  RandomPokemonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomPokemonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomPokemonHash();

  @$internal
  @override
  $FutureProviderElement<Pokemon?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Pokemon?> create(Ref ref) {
    return randomPokemon(ref);
  }
}

String _$randomPokemonHash() => r'a2ccc88d196a18b604d0152c8a62667df9c05335';

@ProviderFor(pokemonDetails)
final pokemonDetailsProvider = PokemonDetailsFamily._();

final class PokemonDetailsProvider
    extends
        $FunctionalProvider<AsyncValue<Pokemon?>, Pokemon?, FutureOr<Pokemon?>>
    with $FutureModifier<Pokemon?>, $FutureProvider<Pokemon?> {
  PokemonDetailsProvider._({
    required PokemonDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'pokemonDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pokemonDetailsHash();

  @override
  String toString() {
    return r'pokemonDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Pokemon?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Pokemon?> create(Ref ref) {
    final argument = this.argument as int;
    return pokemonDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PokemonDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pokemonDetailsHash() => r'd7bcf9d99a240e4a3155b3ecaf3b3dbf4352d10a';

final class PokemonDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Pokemon?>, int> {
  PokemonDetailsFamily._()
    : super(
        retry: null,
        name: r'pokemonDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PokemonDetailsProvider call(int id) =>
      PokemonDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'pokemonDetailsProvider';
}
