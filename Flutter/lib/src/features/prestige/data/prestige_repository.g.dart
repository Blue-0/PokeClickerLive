// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestige_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prestigeRepository)
final prestigeRepositoryProvider = PrestigeRepositoryProvider._();

final class PrestigeRepositoryProvider
    extends
        $FunctionalProvider<
          PrestigeRepository,
          PrestigeRepository,
          PrestigeRepository
        >
    with $Provider<PrestigeRepository> {
  PrestigeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prestigeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prestigeRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrestigeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PrestigeRepository create(Ref ref) {
    return prestigeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrestigeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrestigeRepository>(value),
    );
  }
}

String _$prestigeRepositoryHash() =>
    r'0e2a3863232913500a6f9d2c780ddbdb5f4e6c16';
