// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryController)
final inventoryControllerProvider = InventoryControllerProvider._();

final class InventoryControllerProvider
    extends $NotifierProvider<InventoryController, Inventory> {
  InventoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryControllerHash();

  @$internal
  @override
  InventoryController create() => InventoryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Inventory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Inventory>(value),
    );
  }
}

String _$inventoryControllerHash() =>
    r'45b95b955d1eb57ded89b379792907cad58277d9';

abstract class _$InventoryController extends $Notifier<Inventory> {
  Inventory build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Inventory, Inventory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Inventory, Inventory>,
              Inventory,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
