# Story 2.1: Fetch Pokemon Data from PokéAPI

**Epic:** 2 - Data & Assets (Pokédex)
**Status:** ready-for-dev
**As a:** Developer
**I want to:** fetch Pokémon data from PokéAPI
**So that:** the game displays real Pokémon instead of placeholders.

## Context
We need to integrate with PokéAPI to get:
- Pokémon ID, Name, Sprite URL
- Base Stats (for future HP/Attack calculations)

Focus on Sinnoh Region (IDs 387-493) as per GDD.

## Technical Requirements
- **HTTP Client:** Use `dio` package for network calls.
- **Data Model:** Create `Pokemon` domain entity (Freezed).
- **Repository Pattern:** `PokemonRepository` handles API calls.
- **Caching:** Use `cached_network_image` for sprites (already in deps).

## Acceptance Criteria
- [ ] `Pokemon` data class created with: `id`, `name`, `spriteUrl`, `hp`, `attack`.
- [ ] `PokemonRepository` fetches data from `https://pokeapi.co/api/v2/pokemon/{id}`.
- [ ] Random Sinnoh Pokémon can be fetched for encounters.
- [ ] Error handling for network failures (return `Either<Failure, Pokemon>`).

## API Reference
```
GET https://pokeapi.co/api/v2/pokemon/{id_or_name}
Response:
{
  "id": 387,
  "name": "turtwig",
  "sprites": { "front_default": "https://..." },
  "stats": [
    { "base_stat": 55, "stat": { "name": "hp" } },
    { "base_stat": 68, "stat": { "name": "attack" } },
    ...
  ]
}
```

## Dependencies
- `dio` (HTTP)
- `fpdart` (Either for error handling)
- `freezed_annotation` (Data classes)
