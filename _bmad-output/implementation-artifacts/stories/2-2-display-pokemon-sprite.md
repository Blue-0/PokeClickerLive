# Story 2.2: Display Pokemon Sprite

**Epic:** 2 - Data & Assets (Pokédex)
**Status:** ready-for-dev
**As a:** Player
**I want to:** see real Pokémon sprites instead of placeholder squares
**So that:** the game feels authentic and engaging.

## Context
Story 2-1 created the data fetching layer. Now we integrate it into the UI to replace the red square with actual Pokémon sprites.

## Technical Requirements
- Use `cached_network_image` for efficient sprite loading.
- Update `ClickerController` to hold current Pokémon data.
- Show loading state while fetching.
- On defeat, fetch a NEW random Pokémon.

## Acceptance Criteria
- [ ] Red square replaced by Pokémon sprite image.
- [ ] Pokémon name displayed above/below sprite.
- [ ] Loading indicator shown while fetching.
- [ ] New Pokémon spawns after defeating current one.
- [ ] HP is derived from Pokémon's actual base HP stat.

## Dependencies
- Story 2-1 (PokemonRepository)
- `cached_network_image` package
