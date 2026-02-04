// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_save_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cloudSaveRepository)
final cloudSaveRepositoryProvider = CloudSaveRepositoryProvider._();

final class CloudSaveRepositoryProvider
    extends
        $FunctionalProvider<
          CloudSaveRepository,
          CloudSaveRepository,
          CloudSaveRepository
        >
    with $Provider<CloudSaveRepository> {
  CloudSaveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cloudSaveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cloudSaveRepositoryHash();

  @$internal
  @override
  $ProviderElement<CloudSaveRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloudSaveRepository create(Ref ref) {
    return cloudSaveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloudSaveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloudSaveRepository>(value),
    );
  }
}

String _$cloudSaveRepositoryHash() =>
    r'fa56d991622ce760bdd1190c1f81ba37cde74045';
