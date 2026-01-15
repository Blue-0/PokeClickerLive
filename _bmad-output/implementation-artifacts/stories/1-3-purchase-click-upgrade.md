# Story 1.3: Purchase Click Upgrade

**Epic:** 1 - The Core Loop (MVP)
**Status:** ready-for-dev
**As a:** Player
**I want to:** purchase upgrades to increase my click damage
**So that:** I can defeat Pokémon faster and progress more efficiently.

## Context
Players earn currency but have nothing to spend it on. We need a basic upgrade shop.

## Technical Requirements
- Create `Upgrade` domain model (name, cost, multiplier)
- Create `ShopController` with Riverpod
- Create `ShopScreen` UI with list of upgrades
- Integrate upgrade effects into `ClickerController`

## Upgrade Types (V1)
1. **Click Power** - Increases damage per click (+1 per level)
2. **Auto Clicker** - Passive damage per second (unlocks idle income)

## Acceptance Criteria
- [ ] Shop button visible on main screen
- [ ] Shop screen shows available upgrades with costs
- [ ] Player can purchase upgrade if sufficient currency
- [ ] Currency deducted on purchase
- [ ] Click damage increases after purchase
- [ ] Auto clicker deals passive damage (if purchased)

## Data Model
```dart
Upgrade {
  String id;
  String name;
  int level;
  int baseCost;
  double multiplier; // cost = baseCost * (multiplier ^ level)
}
```

## Dependencies
- Story 1-1 (ClickerController)
