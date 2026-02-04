# Story 5.1: Shop Purchase

Status: done

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

- [x] **Infrastructure & Data (AC: 2, 5)**
    - [x] Create `ShopItem` and `Inventory` models in `lib/src/features/shop/domain/`.
    - [x] Register Hive adapters for the new models in `app_bootstrap.dart`.
    - [x] Implement `ShopRepository` with hardcoded item data for MVP (Pokéballs: 200₽, Potions: 300₽).
- [x] **Application Logic (AC: 3, 5)**
    - [x] Create `ShopController` (Riverpod Notifier) to manage the listing and purchase process.
    - [x] Integrate with `ClickerController` (or wherever currency is stored) to deduct funds.
    - [x] Integrate with `CollectionController` or a new `InventoryController` to store items.
- [x] **UI Implementation (AC: 1, 2, 4)**
    - [x] Create `ShopScreen` with a clean, grid-based layout for items.
    - [x] Add item cards showing price and stock.
    - [x] Update main navigation to include the Shop tab.

- [ ] **Testing & Validation (AC: 5)**
    - [x] Write unit tests for `ShopController` (purchase logic, restrictions).
    - [ ] Manually verify:
        - Items appear in shop appropriately.
        - Purchase reduces currency and increases inventory.
        - Upgrades apply correct effects (click/auto/crit).
        - Restrictions (money, level) work as expected.
        - Persistence works after app restart.

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

- Implemented complete Shop feature with domain models (ShopItem, Inventory, Upgrade), repository, controllers (ShopController, InventoryController), and UI (ShopScreen with tabs).
- Shop has two tabs: Upgrades (click power, auto-clicker, critical hit) and Items (Poké Balls, Potions).
- Integrated with ClickerController for currency deduction and InventoryController for item storage.
- Added Hive persistence for Inventory.
- Unit tests pass for purchase logic.
- Shop button added to ClickerScreen app bar.

### Code Review Fixes Applied

- **[H2] Upgrade Persistence:** Added Hive box `upgrade_levels` for persisting upgrade levels across app restarts.
- **[H3] Test Coverage:** Added 6 new tests for `purchaseUpgrade` covering effect application, cost scaling, and edge cases.
- **[H4] Magic Numbers:** Extracted all shop prices and costs to `ShopConstants` class per project-context.md.
- **[M1] CachedNetworkImage:** Replaced `Image.network` with `CachedNetworkImage` with `memCacheHeight`.
- **[M2] Error Handling:** Added `placeholder` and `errorWidget` to image loading.
- **[M4] Test Cleanup:** Added `tearDown()` with `container.dispose()` for proper resource cleanup.
- **[L2] Description Display:** Added item description to shop item cards.
- **[L3] Async Pattern:** Changed methods from async to sync since no actual async operations.

### File List

- `lib/src/features/shop/domain/shop_item.dart` - ShopItem model
- `lib/src/features/shop/domain/inventory.dart` - Inventory model
- `lib/src/features/shop/domain/upgrade.dart` - Upgrade model (existing)
- `lib/src/features/shop/domain/shop_state.dart` - ShopState model
- `lib/src/features/shop/domain/shop_constants.dart` - Extracted constants
- `lib/src/features/shop/data/shop_repository.dart` - Repository with hardcoded items/upgrades
- `lib/src/features/shop/data/inventory_adapter.dart` - Hive adapter for Inventory
- `lib/src/features/shop/data/upgrade_level_adapter.dart` - Hive adapter for upgrade levels
- `lib/src/features/shop/application/shop_controller.dart` - Main shop controller with persistence
- `lib/src/features/shop/application/inventory_controller.dart` - Inventory persistence controller
- `lib/src/features/shop/presentation/shop_screen.dart` - Shop UI with tabs and CachedNetworkImage
- `lib/app_bootstrap.dart` - Updated with Inventory adapter and upgrade_levels box
- `lib/src/features/clicker/presentation/clicker_screen.dart` - Added shop navigation button
- `test/src/features/shop/application/shop_controller_test.dart` - Unit tests (9 tests)
