// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TeamController)
final teamControllerProvider = TeamControllerProvider._();

final class TeamControllerProvider
    extends $NotifierProvider<TeamController, TeamState> {
  TeamControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamControllerHash();

  @$internal
  @override
  TeamController create() => TeamController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeamState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeamState>(value),
    );
  }
}

String _$teamControllerHash() => r'2778882fa74937cfe6dddf9a9c6b378959faa001';

abstract class _$TeamController extends $Notifier<TeamState> {
  TeamState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TeamState, TeamState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TeamState, TeamState>,
              TeamState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
