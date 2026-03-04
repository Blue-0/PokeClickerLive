-- Migration: Add game_state column to users table
-- This column stores the full game state JSON for server-side persistence
-- so that progress is restored when the player reconnects on any device.

ALTER TABLE users
ADD COLUMN IF NOT EXISTS game_state jsonb DEFAULT NULL;

COMMENT ON COLUMN users.game_state IS 'Full serialized game state (clicker, shop, world, prestige, inventory) for cloud save restore';
