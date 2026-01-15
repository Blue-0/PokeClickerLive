# Data Models - PokeClickerLive Backend
Generated: 2026-01-15T19:54:01+01:00

## Database schema (Postgres via Supabase)

### Table: `users`
Represents the player account.
- `id` (BigInt, PK)
- `username` (Varchar)
- `email` (Varchar)
- `password_hash` (Varchar)
- `pokedollars` (Numeric) - Current balance
- `lifetime_earnings` (Numeric)
- `total_clicks` (BigInt)
- `latitude` (Double)
- `longitude` (Double)
- `last_sync` (Timestamp)

### Table: `user_pokemon`
Inventory of Pokémon owned by players.
- `user_id` (BigInt, PK, FK -> users)
- `pokemon_id` (BigInt, PK, FK -> ref_pokemon)
- `quantity` (Integer)
- `date_acquired` (Timestamp)

### Table: `ref_pokemon` (Reference)
Static Reference Data for Pokémon.
- `id` (BigInt, PK)
- `name` (Varchar)
- `description` (Text)
- `base_cost` (Numeric)
- `base_production` (Numeric)
- `rarity` (Varchar)
- `region_origin` (Varchar)

### Table: `transaction_logs`
Audit log for economic actions.
- `id` (BigInt, PK)
- `user_id` (BigInt, FK)
- `transaction_type` (Varchar)
- `amount` (Numeric)
- `description` (Text)
- `timestamp` (Timestamp)

### Other Tables (Infrastructure / Upgrades)
- `ref_infrastructures`, `user_infrastructures`
- `ref_upgrades`, `user_upgrades`
- `auth_logs`
