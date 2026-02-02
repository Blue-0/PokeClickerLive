// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository providing zone data.
/// For MVP, zones are hardcoded. In future, could load from JSON/API.

@ProviderFor(zoneRepository)
final zoneRepositoryProvider = ZoneRepositoryProvider._();

/// Repository providing zone data.
/// For MVP, zones are hardcoded. In future, could load from JSON/API.

final class ZoneRepositoryProvider
    extends $FunctionalProvider<ZoneRepository, ZoneRepository, ZoneRepository>
    with $Provider<ZoneRepository> {
  /// Repository providing zone data.
  /// For MVP, zones are hardcoded. In future, could load from JSON/API.
  ZoneRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneRepositoryHash();

  @$internal
  @override
  $ProviderElement<ZoneRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ZoneRepository create(Ref ref) {
    return zoneRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZoneRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZoneRepository>(value),
    );
  }
}

String _$zoneRepositoryHash() => r'5484f61596552a7c5b2c1d5984fddcd1e9bff8bd';
