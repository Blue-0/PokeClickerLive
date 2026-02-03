// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_dps_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(teamDps)
final teamDpsProvider = TeamDpsProvider._();

final class TeamDpsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  TeamDpsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamDpsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamDpsHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return teamDps(ref);
  }
}

String _$teamDpsHash() => r'aad21ae2c2bfab97ef06f15a9e38ac90406b714a';
