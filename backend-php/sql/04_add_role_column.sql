-- Migration: Add role column to users table
-- Allows players to be promoted to admin role for back-office access.
-- Default is 'player' so existing rows are unaffected.

ALTER TABLE users
ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'player';

COMMENT ON COLUMN users.role IS 'User role: player (default) or admin';
