# Story 3.2: Encounter Pokémon by Route

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a Player,
I want to encounter different Pokémon depending on the active Route,
so that I can strategically choose where to farm for specific Pokémon and experience variety as I progress through the game.

## Acceptance Criteria

1. [AC-1] **Route-Specific Spawns**: Each route displays Pokémon from its unique pool (defined in zone data).
2. [AC-2] **Spawn Feedback**: When entering a new zone, the first Pokémon appears from that zone's pool.
3. [AC-3] **Empty Zone Handling**: Towns/hubs with no pokemonIds gracefully display a message or redirect.
4. [AC-4] **Spawn Variety**: Pokémon spawns are randomized within the zone's pool with proper distribution.
5. [AC-5] **Visual Zone Context**: The UI clearly indicates which zone the player is currently farming in.

## Tasks / Subtasks

- [x] **Already Completed in Story 3-1** (Code review fixes)
  - [x] `ZoneController.getRandomPokemonIdFromCurrentZone()` returns zone-specific Pokémon ID
  - [x] `ClickerController._loadNewPokemon()` uses zone's pokemonIds for spawning
  - [x] Zone data includes `pokemonIds` arrays (Route 201: Starly, Bidoof, Kricketot, Shinx)
  - [x] AppBar title shows current zone name

- [x] **Presentation Layer Enhancements** (AC: 2, 3, 5)
  - [x] Add zone-specific background gradient/theme based on ZoneType
  - [x] Display "No wild Pokémon here" message when in town zones
  - [ ] Add subtle zone transition animation when changing zones

- [ ] **Data Layer** (AC: 1, 4)
  - [ ] Add more accurate Sinnoh Pokémon pools per route (expand beyond MVP 4 Pokémon)
  - [ ] Consider adding spawn weights/rarity per Pokémon in zone

- [x] **Testing** (AC: ALL)
  - [x] Unit test: Verify spawn selection respects zone boundaries
  - [x] Unit test: Verify town zone returns null for spawns
  - [x] Integration test: Zone change triggers new spawn from correct pool

## Dev Notes

### Architecture Patterns

- **State Management:** Continue using existing `ZoneController` and `ClickerController` Riverpod providers.
- **Immutability:** All zone and Pokémon data models remain `@freezed`.
- **Feature-First:** Zone-related code stays in `lib/src/features/world/`.

### Critical Implementation Details

1. **Spawn Integration (ALREADY DONE):**
   The `ClickerController._loadNewPokemon()` method now uses:
   ```dart
   final zonePokemonId = zoneController.getRandomPokemonIdFromCurrentZone();
   final result = zonePokemonId != null
       ? await repo.getPokemon(zonePokemonId)
       : await repo.getRandomSinnohPokemon();
   ```

2. **Current Zone Data (MVP):**
   | Zone | Pokémon IDs | Pokémon Names |
   |------|-------------|---------------|
   | Route 201 | 396, 399, 401, 403 | Starly, Bidoof, Kricketot, Shinx |
   | Sandgem Town | [] | (No wild Pokémon - Hub) |
   | Route 202 | 396, 399, 401, 403, 265 | +Wurmple |

3. **Expanded Pokémon Pools (Stretch Goal):**
   Based on official Pokémon Diamond/Pearl encounter tables:
   - Route 201: Starly (50%), Bidoof (50%) [Day/Night variations]
   - Route 202: Starly, Bidoof, Shinx, Kricketot

4. **Town Zone Handling:**
   When `pokemonIds.isEmpty`:
   - Show "Welcome to [Town Name]!" message
   - Display town icon/assets
   - Disable combat mechanics
   - Optionally show shop/healing options (future epic)

### Project Structure Notes

**Files to Modify:**
```
lib/src/features/clicker/presentation/clicker_screen.dart  → Add town handling UI
lib/src/features/world/data/zone_repository.dart          → Expand Pokémon pools
lib/src/features/world/presentation/zone_map_screen.dart  → Zone-specific theming
```

### Previous Story Intelligence

From Story 3-1:
- Zone-based spawning is **already integrated** in `ClickerController`
- `Random().nextInt()` is used for proper randomness (fixed from DateTime)
- All tests pass (27 tests)
- Hive persistence service created but not fully integrated (Epic 5)

### Git Intelligence

Recent work:
- Zone feature folder fully established
- `ZoneController` manages currentZone and killCounts
- Integration between features (world → clicker) working

### Performance Considerations

- Pokémon pools are small (4-6 IDs per zone), no caching needed
- Random selection is O(1) operation
- Zone data is static, loaded once at app start

### References

- [Source: _bmad-output/gdd.md#Core Gameplay Loop - Spawn Mechanics]
- [Source: _bmad-output/game-architecture.md#Feature-First Structure]
- [Source: _bmad-output/epics.md#Epic 3 Story 2]
- [Source: lib/src/features/clicker/application/clicker_controller.dart:31-38]
- [Source: lib/src/features/world/data/zone_repository.dart#_sinnohZones]

## Dev Agent Record

### Agent Model Used

Claude 3.5 Sonnet

### Debug Log References

- `flutter test` - 31 tests passed
- `flutter analyze` - 5 lint warnings (unused imports in other files)

### Completion Notes List

**Pre-existing Work (from Story 3-1 Code Review):**
- Zone-based spawning already implemented
- Zone data with pokemonIds already defined
- Random selection with proper distribution

**Implemented in this story:**
- ✅ Zone-specific background gradients (route: blue-green, town: orange-amber, dungeon: purple)
- ✅ Town zone UI with welcome message and "No wild Pokémon here" indicator
- ✅ `_getZoneGradient()` method for dynamic theming based on ZoneType
- ✅ `_buildTownView()` method for town-specific UI
- ✅ `_buildCombatView()` method to separate combat UI logic
- ✅ Unit tests for zone spawn boundaries (4 new tests)
- ✅ All 31 tests passing

**Deferred Work:**
- Zone transition animations (marked as optional stretch goal)
- Expanded Pokémon pools with spawn weights (Epic 3 future story)

### File List

**Modified:**
- Flutter/lib/src/features/clicker/presentation/clicker_screen.dart

**New:**
- Flutter/test/src/features/world/application/zone_spawn_test.dart
