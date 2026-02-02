import 'package:freezed_annotation/freezed_annotation.dart';

part 'unlock_condition.freezed.dart';
part 'unlock_condition.g.dart';

/// Represents the condition required to unlock a zone.
@freezed
abstract class UnlockCondition with _$UnlockCondition {
  const factory UnlockCondition({
    /// Number of Pokémon defeats required in the source zone
    required int killCount,

    /// The zone where kills must be made to unlock this zone
    required String sourceZoneId,
  }) = _UnlockCondition;

  factory UnlockCondition.fromJson(Map<String, dynamic> json) =>
      _$UnlockConditionFromJson(json);
}
