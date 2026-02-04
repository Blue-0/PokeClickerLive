# Story 5.3: Prestige Reset

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want to perform a Prestige Reset,
so that I can gain Badges and multipliers to accelerate my progression.

## Acceptance Criteria

1. **[AC-1] Reset Trigger**: The player must be able to trigger a Prestige Reset from the Settings/Profile or a dedicated menu once reaching a specific milestone (e.g., defeating the boss of Route 10).
2. **[AC-2] State Reset**: Upon reset, the following must be reset to their initial values:
    - Currency (Money)
    - Click Damage (Upgrades purchased in Shop)
    - World Progress (Locked routes reset to Route 201)
    - Inventory (except for key items/Badges)
3. **[AC-3] Prestige Rewards**: The player receives:
    - 1 Prestige Point / Badge (visual progression marker).
    - A permanent Multiplier (e.g., +10% Damage & Currency gain per prestige level).
4. **[AC-4] Confirmation Dialog**: A clear, destructive action confirmation dialog must be shown before the reset, explaining what will be lost and what will be gained.
5. **[AC-5] Persistence & Sync**: Prestige data (level, total points, multipliers) must be stored in Hive and included in the `CloudSaveSync` payload.

## Tasks / Subtasks

- [ ] **Domain: Prestige Model (AC: 3, 5)**
    - [ ] Create `PrestigeState` using `@freezed` with `prestigeLevel`, `totalBadges`, and calculated `multiplier`.
- [ ] **Data: Persistence (AC: 5)**
    - [ ] Create `PrestigeRepository` to handle Hive storage for prestige statistics.
    - [ ] Add `PrestigeAdapter` to `app_bootstrap.dart`.
- [ ] **Application: Reset Logic (AC: 2, 3)**
    - [ ] Create `PrestigeController` (Riverpod `Notifier`).
    - [ ] Implement `performPrestigeReset()`:
        - [ ] Clear `Money` and `Upgrades` in `ClickerController`.
        - [ ] Reset `WorldState` to Route 201.
        - [ ] Increment `prestigeLevel` and save.
- [ ] **UI: Reset Interface (AC: 1, 4)**
    - [ ] Add a "Prestige" button in the Shop or Settings (visible only when available).
    - [ ] Implement `PrestigeConfirmationDialog`.

## Dev Notes

- **State Reset**: Use `ref.invalidate(provider)` where possible, or add explicit `reset()` methods to `ClickerController` and `WorldController` if complex cleanup is needed.
- **Multipliers**: Ensure `ClickerController` reads the `prestigeMultiplier` from the `PrestigeController` when calculating damage.
- **Architecture**: Follow the Feature-First structure in `lib/src/features/prestige/`.
- **Sync**: Update `SyncController` (State Aggregator) to include the new prestige data in the cloud save JSON.

### Project Structure Notes

- New feature: `prestige`.
- Impacted features: `clicker` (damage calc), `world` (reset), `sync` (data aggregation), `shop` (trigger location).

### References

- [Source: Flutter/lib/src/features/sync/application/sync_controller.dart] (For state aggregation example)
- [Source: _bmad-output/game-architecture.md#Decision Summary]
- [Source: _bmad-output/epics.md#Epic 5]

## Dev Agent Record

### Agent Model Used

Antigravity (Gemini 2.0 Flash)

### Debug Log References

### Completion Notes List

### File List
