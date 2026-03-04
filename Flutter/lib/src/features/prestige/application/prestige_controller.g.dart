// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestige_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PrestigeController)
final prestigeControllerProvider = PrestigeControllerProvider._();

final class PrestigeControllerProvider
    extends $NotifierProvider<PrestigeController, PrestigeData> {
  PrestigeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prestigeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prestigeControllerHash();

  @$internal
  @override
  PrestigeController create() => PrestigeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrestigeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrestigeData>(value),
    );
  }
}

String _$prestigeControllerHash() =>
    r'1db72c9e5ce7a68dc0371f1115af8faba81ae279';

abstract class _$PrestigeController extends $Notifier<PrestigeData> {
  PrestigeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PrestigeData, PrestigeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PrestigeData, PrestigeData>,
              PrestigeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
