# Story 4.2: Select Active Team

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want to select 6 Pokémon to form my Active Team,
so that I can use their strength to increase my combat effectiveness.

## Acceptance Criteria

1. **[AC-1] Team State**: The system maintains an "Active Team" consisting of up to 6 unique instances of Pokémon selected from the player's collection.
2. **[AC-2] Persistence**: The active team selection is saved to disk (Hive) so it survives app restarts.
3. **[AC-3] Team Management UI**:
   - A dedicated tab or screen to view the 6 active team slots.
   - A way to assign a Pokémon from the collection (Box/PC) to an empty slot or swap with an occupied slot.
   - A way to remove a Pokémon from a team slot.
4. **[AC-4] Data Integrity**:
   - A team can have at most 6 Pokémon.
   - A specific `UserPokemon` instance (unique ID) can only occupy one slot at a time.
5. **[AC-5] Visual Feedback**: The UI clearly highlights which Pokémon in the collection are currently "Active" in the team.
6. **[AC-6] Cross-Feature Access**: The team state is accessible via a Riverpod provider for use in future combat calculations (Passive DPS).

## Tasks / Subtasks

- [x] **Domain Layer (Team)**
  - [x] Define `TeamState` with a list of active `UserPokemon` IDs.
  - [x] Update `CollectionState` or create `TeamState` to track active status.
- [x] **Data Layer (Persistence)**
  - [x] Implement `TeamRepository` using Hive to store the IDs of the 6 active Pokémon.
  - [x] Register any necessary adapters in `app_bootstrap.dart`.
- [x] **Application Layer (Logic)**
  - [x] Create `TeamController` (NotifierProvider) to manage team selection, removal, and swapping.
  - [x] Ensure `TeamController` interacts correctly with `CollectionController`.
- [x] **Presentation Layer (UI)**
  - [x] Create a `TeamScreen` or `TeamTab` to display the active team (6 slots).
  - [x] Implement the selection interface (Grid of slots + List of collection).
  - [x] Add a navigation entry (IconButton in AppBar or BottomNav) to access the Team view.
- [x] **Testing**
  - [x] Unit Test: `TeamController` prevents adding more than 6 Pokémon.
  - [x] Unit Test: `TeamController` handles swapping correctly.
  - [x] Unit Test: Persistence saves and loads the team correctly.

## Dev Notes

### Architecture & Patterns
- **Feature Location:** Place under `lib/src/features/collection/` (as it's closely tied to managing owned Pokémon) or create `lib/src/features/team/`. Given the "Collection" focus of managing owned assets, keeping it nearby is fine, but a separate feature module is cleaner for scaling.
- **State Management:** Use `NotifierProvider` for `TeamController`.
- **UI Design:** Draw inspiration from the Nintendo DS GBA/DS box interface. 6 large slots at the top, a grid of owned Pokémon below.

### Critical Implementation Details
- **ID Reference:** Store the `UserPokemon.id` (UUID) in the team list, NOT the species ID, as players can have multiple Tortipouss and need to choose which specific one to include.
- **Async Safety:** Ensure the collection is loaded before trying to resolve the team members.

### References
- [GDD](../../gdd.md) (Epic 4: Combat Systems)
- [Game Architecture](../../game-architecture.md)
- [Story 4.1: Capture Mechanics](./4-1-capture-pokemon.md)

## Dev Agent Record

### Agent Model Used

Antigravity (Gemini 2.0 Flash)

### Completion Notes List

- Implemented TeamState domain model with Freezed.
- Implemented TeamRepository using Hive for persistent storage of active team IDs.
- Created TeamController for team management logic (add, remove, swap).
- Developed TeamScreen UI with active slots and collection view.
- Added navigation to TeamScreen from ClickerScreen.
- Verified logic with unit tests and mocked repository.

### File List

- Flutter/lib/src/features/collection/domain/team_state.dart
- Flutter/lib/src/features/collection/application/team_controller.dart
- Flutter/lib/src/features/collection/data/team_repository.dart
- Flutter/lib/src/features/collection/presentation/team_screen.dart
- Flutter/lib/src/features/clicker/presentation/clicker_screen.dart
- Flutter/lib/src/features/pokemon/application/pokemon_provider.dart
- Flutter/lib/app_bootstrap.dart
- Flutter/test/src/features/collection/application/team_controller_test.dart
