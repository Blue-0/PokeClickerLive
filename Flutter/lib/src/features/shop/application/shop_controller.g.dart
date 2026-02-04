// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShopController)
final shopControllerProvider = ShopControllerProvider._();

final class ShopControllerProvider
    extends $NotifierProvider<ShopController, ShopState> {
  ShopControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopControllerHash();

  @$internal
  @override
  ShopController create() => ShopController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShopState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShopState>(value),
    );
  }
}

String _$shopControllerHash() => r'd4d5bb1e53002c7eef28488f205613757788df10';

abstract class _$ShopController extends $Notifier<ShopState> {
  ShopState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ShopState, ShopState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShopState, ShopState>,
              ShopState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
