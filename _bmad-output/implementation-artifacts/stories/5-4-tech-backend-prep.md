# Story 5.4: Backend Tech Prep & Cloud Sync Stub

**Epic:** 5 - Economy & Meta
**Status:** ready-for-dev
**As a:** Developer
**I want to:** ensure the Backend API is robust and ready for Flutter integration
**So that:** the frontend team can implement the `catch` and `sync` features without blocking issues.

## Context
The Flutter app will need to talk to the PHP backend. We have existing endpoints but need to verify their robustness and prepare a `sync` endpoint for the "Offline Progress" feature (Time Skip).

## Data & State
*   **Existing Endpoints:** `/api/pokemon/catch`, `/api/auth/*`
*   **New Endpoint Needed:** `/api/user/sync` (Stub for now)

## Acceptance Criteria
- [ ] **Endpoint `/api/pokemon/catch` Refined**:
    - [ ] Returns explicit error code `402 Payment Required` if not enough money (currently generic 400).
    - [ ] Returns `404` if Pokémon ID invalid.
    - [ ] Returns `401` if Token invalid.
- [ ] **New Endpoint `/api/user/sync` Created**:
    - [ ] Accepts `POST` with JSON payload: `{ "last_sync": "timestamp", "local_data": { ... } }`.
    - [ ] Returns `200 OK` with `{ "server_timestamp": "...", "cloud_data": null }` (Stub behavior).
    - [ ] This prepares the contract for future implementations.
- [ ] **API Documentation Updated**:
    - [ ] Update `api-contracts.md` with these changes.

## Technical Notes
- Use `App\Utils\JWT` for auth checks.
- Keep the actual Sync logic simple/empty for now (V1 scope is just the contract).

## Dependencies
- `backend-php/src/Controllers/Api/PokemonApiController.php`
- `backend-php/routes.php` (if applicable)

