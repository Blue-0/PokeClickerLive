# Story 5.5: Align PHP Models with DB Schema

**Epic:** 5 - Economy & Meta
**Status:** ready-for-dev
**As a:** Developer
**I want to:** ensure the PHP Models match the actual Database Schema
**So that:** we avoid runtime errors like "Column not found" or composite key failures.

## Context
The provided schema (`dbschema.md`) differs from the current PHP implementation.
- `user_pokemon` has NO `id` column (PK is composite).
- `users` has `numeric` types for money, not int.
- Tables like `ref_infrastructures` are missing models.

## Tasks
- [ ] **Refractor `UserPokemon` Model**:
    - Remove `$primaryKey = 'id'`.
    - Update logic to handle composite keys (insert/update).
- [ ] **Refractor `User` Model**:
    - Ensure typing handles `numeric` correctly (PHP float or string for precision).
- [ ] **Create Missing Models**:
    - `Infrastructure.php`, `Upgrade.php`.
    - `UserInfrastructure.php`, `UserUpgrade.php`.

## Acceptance Criteria
- [ ] PHP Models accurately reflect columns in `dbschema.md`.
- [ ] Inserts into `user_pokemon` work without looking for an `id` column.
