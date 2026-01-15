# Story 1.1: Core Click Loop Implementation

**Epic:** 1 - The Core Loop (MVP)
**Status:** ready-for-dev
**As a:** Player
**I want to:** click on a pokemon to deal damage and earn money
**So that:** I can progress in the game and buy upgrades.

## Context
This is the absolute foundation of the game. We need to set up the Flutter project structure and implement the primary interaction: Use clicks to reduce HP and gain currency.
Although we have a Backend (PHP), **this specific story focuses on the Client-Side logic first**. Synchronization will come in Epic 5.

## Technical Requirements (Flutter)
*   **State Management:** Use `Riverpod` for all state (Currency, HP, Clicks).
*   **Architecture:** Feature-First (`lib/src/features/clicker`).
*   **Performance:** Use `onTap`/`GestureDetector`. Ensure UI updates are smooth (60fps).
*   **Data Models:**
    *   `ClickerState` (Immutable, Freezed): `currentHp`, `maxHp`, `currency`.

## Acceptance Criteria
- [ ] **Project Initialized**: Flutter project created with valid structure.
- [ ] **Clickable Target**: A widget (Red Square or Placeholder) is displayed in the center.
- [ ] **Damage Logic**:
    *   Target has `HP` (e.g., 10).
    *   Clicking deals `1` damage.
    *   When `HP <= 0`, the target "dies" (respawns instantly or after delay) and grants `Money`.
- [ ] **Currency UI**:
    *   Top bar displays current `Pokédollars`.
    *   Updates reactively without full page rebuilds.
- [ ] **Riverpod Setup**:
    *   `ProviderScope` at root.
    *   `ClickerNotifier` handling logic (no logic in UI).

## Developer Notes
*   Refer to `_bmad-output/project-context.md` for specific rules (Freezed, Riverpod, etc.).
*   Keep it simple: No real Pokémon data yet (Just local variables).
*   Do NOT hook up API calls in this story (Keep it local).

## Dependencies
*   `flutter_riverpod`
*   `freezed_annotation`
