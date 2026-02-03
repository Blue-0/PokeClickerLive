// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollectionController)
final collectionControllerProvider = CollectionControllerProvider._();

final class CollectionControllerProvider
    extends $NotifierProvider<CollectionController, CollectionState> {
  CollectionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionControllerHash();

  @$internal
  @override
  CollectionController create() => CollectionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionState>(value),
    );
  }
}

String _$collectionControllerHash() =>
    r'5874a77047ae35552e178a55b6674cdb2d96f192';

abstract class _$CollectionController extends $Notifier<CollectionState> {
  CollectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CollectionState, CollectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CollectionState, CollectionState>,
              CollectionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
