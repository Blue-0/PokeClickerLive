// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CaptureService)
final captureServiceProvider = CaptureServiceProvider._();

final class CaptureServiceProvider
    extends $NotifierProvider<CaptureService, void> {
  CaptureServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureServiceHash();

  @$internal
  @override
  CaptureService create() => CaptureService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$captureServiceHash() => r'dda393e11f9fca68412195d63c8001f84547cb5b';

abstract class _$CaptureService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
