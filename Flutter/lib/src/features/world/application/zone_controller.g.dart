// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for managing zone selection and progression

@ProviderFor(ZoneController)
final zoneControllerProvider = ZoneControllerProvider._();

/// Controller for managing zone selection and progression
final class ZoneControllerProvider
    extends $NotifierProvider<ZoneController, ZoneState> {
  /// Controller for managing zone selection and progression
  ZoneControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneControllerHash();

  @$internal
  @override
  ZoneController create() => ZoneController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZoneState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZoneState>(value),
    );
  }
}

String _$zoneControllerHash() => r'0f2dad89e6367f8fda959d2e5b758ea773c7746c';

/// Controller for managing zone selection and progression

abstract class _$ZoneController extends $Notifier<ZoneState> {
  ZoneState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ZoneState, ZoneState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ZoneState, ZoneState>,
              ZoneState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
