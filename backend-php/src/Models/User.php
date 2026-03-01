<?php
namespace App\Models;

/**
 * User Model
 * Represents a player account with balance, stats, and position
 */
class User extends Model
{
    protected static string $table = 'users';
    protected static string $primaryKey = 'id';

    /**
     * Find a user by email
     */
    public static function findByEmail(string $email): ?array
    {
        $results = self::where('email', 'eq', $email);
        return $results[0] ?? null;
    }

    /**
     * Find a user by username
     */
    public static function findByUsername(string $username): ?array
    {
        $results = self::where('username', 'eq', $username);
        return $results[0] ?? null;
    }

    /**
     * Register a new user
     */
    public static function register(string $username, string $email, string $password): ?array
    {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        return self::create([
            'username' => $username,
            'email' => $email,
            'password_hash' => $hashedPassword,
            'pokedollars' => 0,
            'lifetime_earnings' => 0,
            'total_clicks' => 0,
            'created_at' => date('c')
        ], true);
    }

    /**
     * Register a new user with error details
     */
    public static function registerWithError(string $username, string $email, string $password): array
    {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        return self::createWithError([
            'username' => $username,
            'email' => $email,
            'password_hash' => $hashedPassword,
            'role' => 'player',          // Default role – can be promoted to 'admin' in DB
            'pokedollars' => 0,
            'lifetime_earnings' => 0,
            'total_clicks' => 0,
            'created_at' => date('c')
        ], true);
    }

    /**
     * Verify user credentials
     */
    public static function verifyPassword(array $user, string $password): bool
    {
        return password_verify($password, $user['password_hash'] ?? '');
    }

    /**
     * Update user balance
     */
    public static function updateBalance(int|string $userId, int $amount): ?array
    {
        $user = self::find($userId);
        if (!$user) {
            return null;
        }

        $newBalance = ($user['pokedollars'] ?? 0) + $amount;
        return self::update($userId, ['pokedollars' => $newBalance], true);
    }

    /**
     * Increment click count
     */
    public static function incrementClicks(int|string $userId, int $clicks = 1): ?array
    {
        $user = self::find($userId);
        if (!$user) {
            return null;
        }

        $newClicks = ($user['total_clicks'] ?? 0) + $clicks;
        return self::update($userId, ['total_clicks' => $newClicks], true);
    }

    /**
     * Update user GPS position
     */
    public static function updatePosition(int|string $userId, float $latitude, float $longitude): ?array
    {
        return self::update($userId, [
            'latitude' => $latitude,
            'longitude' => $longitude,
            'last_sync' => date('c')
        ], true);
    }

    /**
     * Get user's safe public data (no password)
     */
    public static function toPublic(array $user): array
    {
        unset($user['password_hash']);
        return $user;
    }
}
