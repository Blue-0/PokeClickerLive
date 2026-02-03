# Story 4.4: Boss Timer Logic

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want to face a Boss with a time limit at the end of each route,
so that I have a significant challenge and a sense of progression when clearing a zone.

## Acceptance Criteria

1. **[AC-1] Boss Encounter Trigger**: When the kill count for a route reaches the target (e.g. 10/10), the next Pokémon encounter should be the zone's Boss if one is defined.
2. **[AC-2] Boss Stats Scaling**: Bosses should have significantly higher HP than regular Pokémon (multiplier defined in zone data or constant).
3. **[AC-3] Countdown Timer**: A 30-second timer (configurable per zone) starts immediately when a Boss encounter begins.
4. **[AC-4] Timer UI**: The remaining time must be clearly displayed on the Clicker screen during a Boss fight.
5. **[AC-5] Timeout Penalty**: If the timer reaches zero, the Boss encounter ends, and the player is returned to regular "Route Farm" mode (encountering random wild Pokémon again).
6. **[AC-6] Victory Rewards**: Defeating a Boss provides a larger currency reward and allows the player to "clear" the zone (enabling the next zone unlock if not already unlocked).

## Tasks / Subtasks

- [x] **Domain & State (AC: 1, 3)**
  - [x] Update `Zone` model in `lib/src/features/world/domain/zone.dart` to include `bossPokemonId` and `bossTimerSeconds`.
  - [x] Add `isBoss` and `remainingBossTime` to `ClickerState` in `lib/src/features/clicker/domain/clicker_state.dart`.
- [x] **Data Initialization (AC: 1, 2)**
  - [x] Update `ZoneRepository` in `lib/src/features/world/data/zone_repository.dart` to define bosses for Route 201 (e.g. Kricketune, ID 402) and Route 202.
- [x] **Combat Logic (AC: 3, 5, 6)**
  - [x] Modify `ClickerController._loadNewPokemon` to check if a Boss should be spawned (if kill count == target).
  - [x] Implement a `Timer` in `ClickerController` specifically for the Boss countdown.
  - [x] Update `_defeatEnemy` to handle Boss specific rewards and reset the Boss state.
  - [x] Implement `_onBossTimeout` to handle the transition back to regular farm mode.
- [x] **Presentation (AC: 4)**
  - [x] Update `ClickerScreen` to display a Boss Badge/Label and the countdown timer.
  - [x] Add a "Battle Boss" button that appears once the kill target is met (optional, or auto-start). *Based on GDD, auto-start or manual trigger from farm.*

## Dev Notes

- **Architecture Compliance**: Use Riverpod `ref.listen` or logic within `ClickerController` to handle the timer. Avoid putting UI-specific timer logic in the widget if possible; keep the countdown in the controller's state.
- **HP Scaling**: For Bosses, calculate `maxHp` as `pokemon.hp * 5` (as a starting point).
- **Timer Frequency**: The Boss timer should tick every 1 second, similar to the auto-clicker.

### Project Structure Notes

- Follow the existing `Feature-First` structure.
- Logic goes in `src/features/clicker/application/clicker_controller.dart`.
- State goes in `src/features/clicker/domain/clicker_state.dart`.

### References

- [GDD](../../gdd.md#challenge-scaling) (Section 11.2.2: The "DPS Wall" Boss)
- [Game Architecture](../../game-architecture.md#tickengine) (TickEngine pattern)
- [Story 4.3: Passive Team DPS](./4-3-passive-team-dps.md)

## Dev Agent Record

### Agent Model Used

Antigravity (Gemini 2.0 Flash)

### Completion Notes List

- Implemented Boss spawning condition based on zone kill target.
- Added Boss data (ID and Timer) for early routes in `ZoneRepository`.
- Implemented HP scaling (x5) and specialized rewards (x5) for Bosses.
- Added a second internal `Timer` in `ClickerController` to manage the 30s countdown.
- UI now displays a red timer bar and a "BOSS" badge during encounters.
- Verified that failing the boss returns the player to regular farm mode.
- **Auto-Fix (AI Review)**: Restored `clicker_controller_test.dart` and fixed Infinite Boss Loop by implementing `decreaseKillCount` penalty on timeout.

### File List

- `lib/src/features/world/data/zone_repository.dart`
- `lib/src/features/world/application/zone_controller.dart`
- `lib/src/features/clicker/application/clicker_controller.dart`
- `lib/src/features/clicker/presentation/clicker_screen.dart`
- `lib/src/features/world/domain/zone.dart`
- `lib/src/features/clicker/domain/clicker_state.dart`
- `test/src/features/world/data/zone_repository_test.dart`
- `test/src/features/clicker/application/clicker_controller_test.dart`
