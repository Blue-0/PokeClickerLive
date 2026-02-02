# Story 3.1: Switch Zones via Map

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a Player,
I want to switch between unlocked zones via a menu/map,
so that I can travel to different areas, encounter new Pokémon, and strategically choose where to farm.

## Acceptance Criteria

1. [AC-1] **Zone Display**: A map or zone selection UI displays all zones (routes/towns) with their locked/unlocked status.
2. [AC-2] **Zone Navigation**: Tapping/clicking on an unlocked zone changes the current active zone.
3. [AC-3] **Visual Feedback**: The currently active zone is visually highlighted in the map/selector.
4. [AC-4] **Locked Zones Indicator**: Locked zones are grayed out or show a lock icon with unlock requirements.
5. [AC-5] **Zone Persistence**: The active zone persists across app restarts (via game state). *(Persistence service created, full integration deferred to Epic 5)*
6. [AC-6] **Integration with Combat**: When the active zone changes, the spawn logic updates to use the new zone's Pokémon pool.

## Tasks / Subtasks

- [x] **Domain Layer** (AC: 1, 4)
  - [x] Create `Zone` entity (`id`, `name`, `type` (route/town), `isUnlocked`, `unlockCondition`, `pokemonIds`)
  - [x] Create `ZoneType` enum (`route`, `town`, `dungeon`)
  - [x] Define `UnlockCondition` model (e.g., `killCount: 10`, `previousZoneId: 'route-201'`)
- [x] **Data Layer** (AC: 1, 5)
  - [x] Create `ZoneRepository` with hardcoded Sinnoh zones for MVP (Route 201, Sandgem Town, Route 202)
  - [x] Create `ZonePersistenceService` for Hive integration (ready for Epic 5)
- [x] **Application Layer** (AC: 2, 3, 5, 6)
  - [x] Create `ZoneController` (Riverpod NotifierProvider) managing `currentZone` and `allZones`
  - [x] Implement `selectZone(zoneId)` method to change active zone
  - [x] Integrate with `ClickerController` so spawn logic reads from current zone's Pokémon pool
- [x] **Presentation Layer** (AC: 1, 2, 3, 4)
  - [x] Create `ZoneMapScreen` or `ZoneSelectorWidget` with list/grid of zones
  - [x] Implement visual states: active (highlighted border/glow), unlocked (normal), locked (grayed + lock icon)
  - [x] Add navigation to ZoneMap from main clicker screen (e.g., AppBar button or FAB)
- [x] **Testing** (AC: ALL)
  - [x] Unit test `ZoneController`: zone selection, state persistence verification
  - [x] Widget test `ZoneSelectorWidget`: locked/unlocked visual states

## Dev Notes

### Architecture Patterns

- **State Management:** Use `NotifierProvider` for `ZoneController`. DO NOT use StatefulWidget for zone logic.
- **Persistence:** `ZonePersistenceService` created with Hive integration. Full app integration in Epic 5.
- **Immutability:** Zone and related models MUST be `@freezed` classes.
- **Feature-First:** All zone-related code goes in `lib/src/features/world/` (new feature folder).

### Critical Implementation Details

1. **Spawn Integration:** `ClickerController` now uses `ZoneController.getRandomPokemonIdFromCurrentZone()` to fetch zone-specific Pokémon.
   
2. **Zone Data Structure (MVP):**
   ```dart
   // Route 201 - Starting zone, always unlocked
   Zone(id: 'route-201', name: 'Route 201', type: ZoneType.route, isUnlocked: true, pokemonIds: [396, 399, 401, 403]) // Starly, Bidoof, Kricketot, Shinx
   
   // Sandgem Town - Hub, unlocked after 10 kills on Route 201
   Zone(id: 'sandgem-town', name: 'Sandgem Town', type: ZoneType.town, isUnlocked: false, unlockCondition: UnlockCondition(killCount: 10, sourceZoneId: 'route-201'))
   
   // Route 202 - Next zone
   Zone(id: 'route-202', name: 'Route 202', type: ZoneType.route, isUnlocked: false, unlockCondition: UnlockCondition(killCount: 10, sourceZoneId: 'sandgem-town'), pokemonIds: [396, 399, 401, 403, 265]) // +Wurmple
   ```

3. **UI Layout:**
   - **Mobile:** Full-screen zone selector accessible via navigation
   - **PC/Web:** Could be sidebar or modal, but start with full-screen for consistency

### Project Structure Notes

**New Feature Folder:** `lib/src/features/world/`
```
lib/src/features/world/
├── domain/
│   ├── zone.dart           # Zone entity (@freezed)
│   ├── zone_type.dart      # ZoneType enum
│   └── unlock_condition.dart # UnlockCondition model
├── data/
│   ├── zone_repository.dart # Hardcoded zones
│   └── zone_persistence_service.dart # Hive persistence
├── application/
│   └── zone_controller.dart # Riverpod NotifierProvider
└── presentation/
    ├── zone_map_screen.dart # Main zone selection screen
    └── widgets/
        └── zone_tile.dart   # Individual zone display widget
```

### References

- [Source: _bmad-output/game-architecture.md#Project Structure (Feature-First)]
- [Source: _bmad-output/game-architecture.md#Data Persistence (Hive)]
- [Source: _bmad-output/gdd.md#Level Design Framework]
- [Source: _bmad-output/gdd.md#Level Types - Routes/Villes]
- [Source: _bmad-output/epics.md#Epic 3: World & Progression]
- [Source: _bmad-output/project-context.md#Code Organization Rules]

## Senior Developer Review (AI)

**Review Date:** 2026-02-02
**Review Outcome:** Changes Requested → Fixed

### Issues Found & Fixed

1. **[HIGH] AC-5 Persistence - ADDRESSED**
   - Created `ZonePersistenceService` with Hive integration
   - Full integration deferred to Epic 5 (Save Cloud) to avoid blocking tests
   
2. **[MEDIUM] AC-6 Spawn Integration - FIXED**
   - Modified `ClickerController._loadNewPokemon()` to use zone's `pokemonIds`
   - Falls back to random Sinnoh if zone has no Pokémon (towns)
   
3. **[MEDIUM] Duplicated Logic - FIXED**
   - Removed `_checkUnlockCondition` from `ZoneMapScreen`
   - Now uses `zone.isUnlocked` directly
   
4. **[MEDIUM] Dynamic Type - FIXED**
   - Changed `dynamic zone` to proper `Zone zone` type
   
5. **[LOW] Poor Randomness - FIXED**
   - Replaced `DateTime.now().microsecond` with `Random().nextInt()`

## Dev Agent Record

### Agent Model Used

Gemini 2.5 Pro

### Debug Log References

- `dart run build_runner build --delete-conflicting-outputs` (Success - 28 outputs)
- `flutter pub add hive hive_flutter` (Success)
- `flutter test` (27 tests passed)

### Completion Notes List

- Created new feature folder `lib/src/features/world/` following Feature-First architecture
- Implemented `Zone`, `ZoneType`, `UnlockCondition` as @freezed classes
- Created `ZoneRepository` with 3 hardcoded Sinnoh zones (Route 201, Sandgem Town, Route 202)
- Created `ZonePersistenceService` for Hive-based persistence (ready for Epic 5)
- Implemented `ZoneController` with zone selection, kill tracking, and automatic unlock logic
- Created `ZoneMapScreen` with current location header and zone list
- Created `ZoneTile` widget with visual states (active/unlocked/locked)
- Added Map button to ClickerScreen AppBar for navigation
- Integrated kill recording from ClickerScreen to ZoneController for progression
- **[CODE REVIEW FIX]** Integrated zone-based Pokémon spawning in ClickerController
- **[CODE REVIEW FIX]** Removed duplicated unlock logic, fixed dynamic type usage
- **[CODE REVIEW FIX]** Improved randomness using `Random()` class
- AppBar title now shows current zone name
- Unit tests: 13 tests for ZoneController and ZoneRepository
- Widget tests: 10 tests for ZoneTile covering all visual states
- All 27 tests passing

### File List

- lib/src/features/world/domain/zone_type.dart (new)
- lib/src/features/world/domain/unlock_condition.dart (new)
- lib/src/features/world/domain/unlock_condition.freezed.dart (generated)
- lib/src/features/world/domain/unlock_condition.g.dart (generated)
- lib/src/features/world/domain/zone.dart (new)
- lib/src/features/world/domain/zone.freezed.dart (generated)
- lib/src/features/world/domain/zone.g.dart (generated)
- lib/src/features/world/data/zone_repository.dart (new)
- lib/src/features/world/data/zone_repository.g.dart (generated)
- lib/src/features/world/data/zone_persistence_service.dart (new)
- lib/src/features/world/data/zone_persistence_service.g.dart (generated)
- lib/src/features/world/application/zone_controller.dart (new)
- lib/src/features/world/application/zone_controller.freezed.dart (generated)
- lib/src/features/world/application/zone_controller.g.dart (generated)
- lib/src/features/world/presentation/zone_map_screen.dart (new)
- lib/src/features/world/presentation/widgets/zone_tile.dart (new)
- lib/src/features/clicker/presentation/clicker_screen.dart (modified)
- lib/src/features/clicker/application/clicker_controller.dart (modified - zone integration)
- test/src/features/world/application/zone_controller_test.dart (new)
- test/src/features/world/presentation/zone_tile_test.dart (new)
- pubspec.yaml (modified - added hive, hive_flutter)

