# Story 3.3: Unlock Route Logic

Status: review

## Story

As a system,
I want to unlock Route 202 only after the player defeats a specific number of Pokémon on Route 201,
so that the player experiences a sense of progression and goal-oriented gameplay.

## Acceptance Criteria

1. [AC-1] **Kill Count Progression**: Defeating a Pokémon in the active Route increments the kill count for that zone.
2. [AC-2] **Unlock Logic Fix**: Route 202 and Sandgem Town unlock after 10 kills on Route 201 (correcting the current broken dependency on town kills).
3. [AC-3] **Visual Progression**: The UI displays the current kill count and the target needed to unlock the next area (e.g., "Kills: 4/10").
4. [AC-4] **Unlock Notification**: A clear visual notification (SnackBar or Toast) appears the moment a new zone is unlocked.
5. [AC-5] **Map Updates**: The Map Screen updates immediately when a zone changes from locked to unlocked status.
6. [AC-6] **Persistence Readiness**: Kill counts are managed in a way that allows future persistence (handled in Epic 5).

## Tasks / Subtasks

- [x] **Domain & Data Layer Updates** (AC: 2)
  - [x] Correct `ZoneRepository` unlock conditions (Route 202 should depend on Route 201 kills).
  - [x] (Optional) Add `targetKills` to `Zone` or `UnlockCondition` if not already flexible.

- [x] **Application Layer Enhancements** (AC: 1, 4)
  - [x] Ensure `ZoneController.recordKill()` triggers a notification when a new zone's `isUnlocked` flips to true.
  - [x] Add a stream or listener for "Unlock Events" to the UI.

- [x] **Presentation Layer** (AC: 3, 5)
  - [x] Add a progress indicator to `ClickerScreen` (e.g., "Route 201: 7 / 10 Kills").
  - [x] Update `ZoneMapScreen` tiles to reflect real-time unlock status (this should already work via Riverpod watch).
  - [x] Implement a SnackBar notification for unlocks.

- [x] **Testing** (AC: ALL)
  - [x] Unit test: `ZoneController` correctly increments kills and flips `isUnlocked`.
  - [x] Widget test: `ClickerScreen` shows correctly updated kill progress.
  - [x] Integration test: Killing the 10th Pokémon triggers the notification and unlocks the next zone.
  - [x] Unit test: Verified Route 202 dependency fix.

## Dev Notes

### Architecture Patterns

- **State Management:** `ZoneController` (Riverpod) already tracks `killCounts`.
- **UI Updates:** `ClickerScreen` should watch `zoneControllerProvider` to show progress.

### Critical Implementation Details

1. **Current Logic in `ZoneController`:**
   ```dart
   void recordKill() {
     final currentId = state.currentZone.id;
     final newCounts = Map<String, int>.from(state.killCounts);
     newCounts[currentId] = (newCounts[currentId] ?? 0) + 1;
     final updatedZones = _checkAndUnlockZones(newCounts); // This logic exists!
     state = state.copyWith(killCounts: newCounts, allZones: updatedZones);
   }
   ```
   *Note:* Need to add notification logic here by comparing old vs new `allZones[i].isUnlocked`.

2. **UI Placement:**
   - The kill progress should probably go under the HP bar on `ClickerScreen`.

3. **Data Fix:**
   - Sandgem Town: 10 kills on Route 201.
   - Route 202: 10 kills on Route 201 (or maybe 10 kills on Route 201? Actually, if Route 201 is done, BOTH should unlock).

### Previous Story Intelligence

- Story 3-1 established the Map and Zone Switching.
- Story 3-2 established Zone-specific spawns and Town UI.
- All 31 tests are passing.

### Git Intelligence

- `ZoneController` is well-tested and robust.
- `ClickerScreen` handles loading states and town views.

## Dev Agent Record

### Agent Model Used

Antigravity (Vertex AI / Gemini 2.0 Flash)

### Debug Log References

- `flutter test` - 35 tests passed
- `dart run build_runner build` - successfully regenerated state
- `flutter analyze` - clean for modified files

### Completion Notes List

- ✅ **Fixed broken unlock dependency:** Route 202 now correctly depends on Route 201 kills instead of impossible Sandgem Town kills.
- ✅ **New Unlock Notification System:** Added `newlyUnlockedZoneNames` (List) to `ZoneState`. `ZoneController` now detects *all* simultaneous unlocks per kill.
- ✅ **SnackBar Integration:** `ClickerScreen` listens to the unlock state and triggers a persistent SnackBar for EACH discovered route.
- ✅ **Progress UI:** Added a "Kills: X / Y" indicator on the combat screen to guide players toward the next unlock.
- ✅ **Real-time Map:** Verified that the world map updates immediately as kills are recorded.
- ✅ **Comprehensive Testing:** Added 6 new tests covering logic fix, notification state (including multi-unlock), and UI progress display.

### File List

- `Flutter/lib/src/features/world/application/zone_controller.dart`
- `Flutter/lib/src/features/world/data/zone_repository.dart`
- `Flutter/lib/src/features/clicker/presentation/clicker_screen.dart`
- `Flutter/test/src/features/world/application/unlock_logic_test.dart`
- `Flutter/test/src/features/clicker/presentation/clicker_progress_test.dart`
