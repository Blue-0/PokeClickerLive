// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clicker_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClickerController)
final clickerControllerProvider = ClickerControllerProvider._();

final class ClickerControllerProvider
    extends $NotifierProvider<ClickerController, ClickerState> {
  ClickerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clickerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clickerControllerHash();

  @$internal
  @override
  ClickerController create() => ClickerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClickerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClickerState>(value),
    );
  }
}

String _$clickerControllerHash() => r'57f2c473d653b40049c447248302f30bf4c03c36';

abstract class _$ClickerController extends $Notifier<ClickerState> {
  ClickerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ClickerState, ClickerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClickerState, ClickerState>,
              ClickerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
