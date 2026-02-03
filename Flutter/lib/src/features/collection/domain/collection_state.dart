import 'package:freezed_annotation/freezed_annotation.dart';
import '../application/capture_service.dart';
import 'user_pokemon.dart';

part 'collection_state.freezed.dart';

@freezed
abstract class CollectionState with _$CollectionState {
  const factory CollectionState({
    @Default(<UserPokemon>[]) List<UserPokemon> ownedPokemon,
    @Default(false) bool isLoading,
    CaptureResult? lastCaptureResult,
  }) = _CollectionState;
}
