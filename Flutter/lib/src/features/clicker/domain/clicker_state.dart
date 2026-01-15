import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokeclickerlive/src/features/pokemon/domain/pokemon.dart';

part 'clicker_state.freezed.dart';

@freezed
abstract class ClickerState with _$ClickerState {
  const factory ClickerState({
    @Default(0) int currency,
    @Default(10) int currentHp,
    @Default(10) int maxHp,
    @Default(1) int level,
    @Default(false) bool isLoading,
    @Default(1) int clickPower,
    @Default(0) int dps,
    @Default(0) int critChance,
    Pokemon? currentPokemon,
  }) = _ClickerState;
}
