# Story 5.1: Shop Purchase

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want to buy Pokéballs and Potions in the Shop,
so that I can expend my resources to improve my collection efficiency and sustain my gameplay.

## Acceptance Criteria

1. **[AC-1] Shop UI Access**: A new tab or screen for the "Shop" must be accessible from the main navigation.
2. **[AC-2] Item Listing**: The shop must display available items (Pokéballs, Potions) with their name, icon/sprite, description, and price in PokéDollars (₽).
3. **[AC-3] Purchase Logic**: Clicking "Buy" must:
    - Check if the player has enough currency.
    - Deduct the price from the player's balance.
    - Add the item to the player's inventory.
    - Provide visual feedback (e.g., balance update, success message/sound).
4. **[AC-4] Inventory Display**: The player must be able to see their current stock of items (e.g., "Pokéballs: 15").
5. **[AC-5] Persistence**: Purchased items and remaining currency must be persisted via Hive and survive app restarts.

## Tasks / Subtasks

- [ ] **Infrastructure & Data (AC: 2, 5)**
    - [ ] Create `ShopItem` and `Inventory` models in `lib/src/features/shop/domain/`.
    - [ ] Register Hive adapters for the new models in `app_bootstrap.dart`.
    - [ ] Implement `ShopRepository` with hardcoded item data for MVP (Pokéballs: 200₽, Potions: 300₽).
- [ ] **Application Logic (AC: 3, 5)**
    - [ ] Create `ShopController` (Riverpod Notifier) to manage the listing and purchase process.
    - [ ] Integrate with `ClickerController` (or wherever currency is stored) to deduct funds.
    - [ ] Integrate with `CollectionController` or a new `InventoryController` to store items.
- [ ] **UI Implementation (AC: 1, 2, 4)**
    - [ ] Create `ShopScreen` with a clean, grid-based layout for items.
    - [ ] Add item cards showing price and stock.
    - [ ] Update main navigation to include the Shop tab.

## Dev Notes

- **Currency Management**: Currency logic is currently tied to `ClickerController`. You may need to expose a `deductCurrency(int amount)` method or refactor currency into its own service if it becomes too complex.
- **Asset Usage**: Use 8-bit style icons for items to match the Gen 4 aesthetic.
- **Persistence**: Ensure `Inventory` is saved every time a purchase is successful.

### Project Structure Notes

- Feature-First: `lib/src/features/shop/`.
- Layers: `domain`, `data`, `application`, `presentation`.

### References

- [GDD](../../gdd.md#investment-shop) (Section 9.1.4: Investissement Shop)
- [Game Architecture](../../game-architecture.md#project-structure-feature-first) (Feature-First pattern)
- [Project Context](../../project-context.md#critical-implementation-rules) (Riverpod & Hive rules)

## Dev Agent Record

### Agent Model Used

Antigravity (Gemini 2.0 Flash)

### Completion Notes List

### File List
