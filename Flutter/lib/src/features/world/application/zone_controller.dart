import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/zone_repository.dart';
import '../domain/zone.dart';

part 'zone_controller.freezed.dart';
part 'zone_controller.g.dart';

/// State for the zone controller
@freezed
abstract class ZoneState with _$ZoneState {
  const factory ZoneState({
    /// All available zones in the game
    required List<Zone> allZones,

    /// Currently active zone (where player is farming)
    required Zone currentZone,

    /// Kill count per zone (for unlock tracking)
    @Default({}) Map<String, int> killCounts,

    /// Newly unlocked zone names (for notifications)
    @Default([]) List<String> newlyUnlockedZoneNames,

    /// Whether state has been loaded from persistence
    @Default(true) bool isInitialized,
  }) = _ZoneState;
}

/// Controller for managing zone selection and progression
@Riverpod(keepAlive: true)
class ZoneController extends _$ZoneController {
  final Random _random = Random();

  @override
  ZoneState build() {
    final repository = ref.watch(zoneRepositoryProvider);
    final allZones = repository.getAllZones();
    final startingZone = repository.getStartingZone();

    return ZoneState(
      allZones: allZones,
      currentZone: startingZone,
      killCounts: {},
      isInitialized: true,
    );
  }

  /// Select a zone as the current active zone
  /// Returns true if selection was successful, false if zone is locked
  bool selectZone(String zoneId) {
    final zone = state.allZones.where((z) => z.id == zoneId).firstOrNull;
    if (zone == null) return false;

    // Check if zone is unlocked
    if (!_isZoneUnlocked(zone)) return false;

    state = state.copyWith(currentZone: zone);
    return true;
  }

  /// Record a kill in the current zone (for unlock progression)
  void recordKill() {
    final currentId = state.currentZone.id;
    final newCounts = Map<String, int>.from(state.killCounts);
    newCounts[currentId] = (newCounts[currentId] ?? 0) + 1;

    // Detect which zones were locked before
    final previouslyLockedIds = state.allZones
        .where((z) => !z.isUnlocked)
        .map((z) => z.id)
        .toSet();

    // Update zones with potential new unlocks
    final updatedZones = _checkAndUnlockZones(newCounts);

    // Find if any previously locked zone is now unlocked
    final newlyUnlockedZones = updatedZones
        .where((z) => previouslyLockedIds.contains(z.id) && z.isUnlocked)
        .map((z) => z.name)
        .toList();

    state = state.copyWith(
      killCounts: newCounts,
      allZones: updatedZones,
      newlyUnlockedZoneNames: newlyUnlockedZones,
    );
  }

  /// Clear the notification for newly unlocked zone
  void clearUnlockNotification() {
    state = state.copyWith(newlyUnlockedZoneNames: []);
  }

  /// Check if a zone is unlocked based on conditions
  bool _isZoneUnlocked(Zone zone) {
    return _isZoneUnlockedWithCounts(zone, state.killCounts);
  }

  /// Check if a zone is unlocked with specific kill counts
  bool _isZoneUnlockedWithCounts(Zone zone, Map<String, int> killCounts) {
    // Zone marked as unlocked
    if (zone.isUnlocked) return true;

    // Check unlock condition
    final condition = zone.unlockCondition;
    if (condition == null) return true;

    final killsInSource = killCounts[condition.sourceZoneId] ?? 0;
    return killsInSource >= condition.killCount;
  }

  /// Check all zones and update their unlock status
  List<Zone> _checkAndUnlockZones(Map<String, int> killCounts) {
    return state.allZones.map((zone) {
      if (zone.isUnlocked) return zone;

      final condition = zone.unlockCondition;
      if (condition == null) return zone.copyWith(isUnlocked: true);

      final killsInSource = killCounts[condition.sourceZoneId] ?? 0;
      if (killsInSource >= condition.killCount) {
        return zone.copyWith(isUnlocked: true);
      }

      return zone;
    }).toList();
  }

  /// Get a random Pokémon ID from the current zone
  /// Returns null if zone has no Pokémon (e.g., towns)
  int? getRandomPokemonIdFromCurrentZone() {
    final pokemonIds = state.currentZone.pokemonIds;
    if (pokemonIds.isEmpty) return null;

    // Use proper Random for better distribution
    final index = _random.nextInt(pokemonIds.length);
    return pokemonIds[index];
  }

  /// Get the kill target for the current zone to unlock the next one(s)
  /// Returns null if no zones depend on this one or all are already unlocked
  int? getKillTargetForCurrentZone() {
    final currentId = state.currentZone.id;
    final dependencies = state.allZones.where((z) {
      return z.unlockCondition?.sourceZoneId == currentId && !z.isUnlocked;
    });

    if (dependencies.isEmpty) return null;

    // Return the minimum kill count required among locked dependencies
    return dependencies
        .map((z) => z.unlockCondition!.killCount)
        .reduce((a, b) => a < b ? a : b);
  }
}
