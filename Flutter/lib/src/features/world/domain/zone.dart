import 'package:freezed_annotation/freezed_annotation.dart';
import 'unlock_condition.dart';
import 'zone_type.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

/// Represents a zone (route, town, dungeon) in the game world.
@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    /// Unique identifier for the zone (e.g., 'route-201')
    required String id,

    /// Display name (e.g., 'Route 201')
    required String name,

    /// Type of zone (route, town, dungeon)
    required ZoneType type,

    /// Whether the zone is currently unlocked for the player
    @Default(false) bool isUnlocked,

    /// Condition to unlock this zone (null if always unlocked)
    UnlockCondition? unlockCondition,

    /// IDs of Pokémon that can spawn in this zone
    @Default([]) List<int> pokemonIds,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}
