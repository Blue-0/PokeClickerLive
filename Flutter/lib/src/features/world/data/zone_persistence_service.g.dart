// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_persistence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for zone persistence service

@ProviderFor(zonePersistenceService)
final zonePersistenceServiceProvider = ZonePersistenceServiceProvider._();

/// Provider for zone persistence service

final class ZonePersistenceServiceProvider
    extends
        $FunctionalProvider<
          ZonePersistenceService,
          ZonePersistenceService,
          ZonePersistenceService
        >
    with $Provider<ZonePersistenceService> {
  /// Provider for zone persistence service
  ZonePersistenceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zonePersistenceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zonePersistenceServiceHash();

  @$internal
  @override
  $ProviderElement<ZonePersistenceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ZonePersistenceService create(Ref ref) {
    return zonePersistenceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZonePersistenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZonePersistenceService>(value),
    );
  }
}

String _$zonePersistenceServiceHash() =>
    r'e2c8e4f4d0301963fa43d92559efbf8f376d4c78';
