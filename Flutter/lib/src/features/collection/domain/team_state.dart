import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_state.freezed.dart';

@freezed
abstract class TeamState with _$TeamState {
  const factory TeamState({
    @Default(<String>[]) List<String> activePokemonIds,
  }) = _TeamState;
}
