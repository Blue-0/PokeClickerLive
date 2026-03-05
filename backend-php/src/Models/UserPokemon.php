<?php
namespace App\Models;

/**
 * UserPokemon Model
 * Represents a player's Pokémon inventory (PC)
 */
class UserPokemon extends Model
{
    protected static string $table = 'user_pokemon';
    protected static array $compositeKey = ['user_id', 'pokemon_id'];

    /**
     * Get all Pokémon owned by a user
     */
    public static function getByUserId(int|string $userId): array
    {
        return self::where('user_id', 'eq', $userId);
    }

    /**
     * Check if user owns a specific Pokémon
     */
    public static function userHasPokemon(int|string $userId, int $pokemonId): bool
    {
        $results = self::where('user_id', 'eq', $userId);
        foreach ($results as $entry) {
            if (($entry['pokemon_id'] ?? 0) == $pokemonId) {
                return true;
            }
        }
        return false;
    }

    /**
     * Add or increment a Pokémon in user's inventory.
     * Uses the actual DB schema: (user_id, pokemon_id, quantity, date_acquired).
     * If the user already owns the Pokémon, the quantity is incremented; otherwise
     * a new row is created with quantity = 1.
     */
    public static function addPokemon(int|string $userId, int $pokemonId): ?array
    {
        $existing = self::findEntry($userId, $pokemonId);

        if ($existing) {
            // Increment quantity
            return self::updateComposite(
                ['user_id' => $userId, 'pokemon_id' => $pokemonId],
                ['quantity' => ($existing['quantity'] ?? 0) + 1],
                true
            );
        }

        $data = [
            'user_id'       => $userId,
            'pokemon_id'    => $pokemonId,
            'quantity'      => 1,
            'date_acquired' => date('c'),
        ];

        return self::create($data, true);
    }

    /**
     * Synchronise la quantité d'un Pokémon côté serveur lors d'un sync périodique.
     * - Si l'entrée n'existe pas, elle est créée avec la quantité client.
     * - Si elle existe, la quantité serveur est mise à jour uniquement si la
     *   quantité client est supérieure (on ne réduit jamais côté serveur pour
     *   éviter la perte de données en cas de client partiel).
     */
    public static function syncQuantity(int|string $userId, int $pokemonId, int $quantity): ?array
    {
        $existing = self::findEntry($userId, $pokemonId);

        if ($existing) {
            $serverQty = (int) ($existing['quantity'] ?? 1);
            if ($quantity > $serverQty) {
                return self::updateComposite(
                    ['user_id' => $userId, 'pokemon_id' => $pokemonId],
                    ['quantity' => $quantity],
                    true
                );
            }
            return $existing;
        }

        return self::create([
            'user_id'       => $userId,
            'pokemon_id'    => $pokemonId,
            'quantity'      => max(1, $quantity),
            'date_acquired' => date('c'),
        ], true);
    }

    /**
     * Ensure a Pokémon exists in the user's inventory (idempotent).
     * Creates the row with quantity = 1 if it does not exist.
     * Does nothing if it already exists. Used by sync to avoid
     * incrementing quantity on every periodic sync.
     */
    public static function ensureExists(int|string $userId, int $pokemonId): ?array
    {
        $existing = self::findEntry($userId, $pokemonId);
        if ($existing) {
            return $existing; // Already present — no-op
        }

        $data = [
            'user_id'       => $userId,
            'pokemon_id'    => $pokemonId,
            'quantity'      => 1,
            'date_acquired' => date('c'),
        ];

        return self::create($data, true);
    }

    /**
     * Find a user pokemon entry by composite key
     */
    public static function findEntry(int|string $userId, int $pokemonId): ?array
    {
        $instance = new static();
        $result = $instance->db->from(
            static::$table,
            '*',
            ['user_id' => 'eq.' . $userId, 'pokemon_id' => 'eq.' . $pokemonId]
        );
        return $result['data'][0] ?? null;
    }

    /**
     * @deprecated The user_pokemon table does NOT have 'level' / 'experience'
     *             columns yet. A SQL migration (ALTER TABLE user_pokemon ADD COLUMN …)
     *             is required before this method can work. Calling it now will
     *             silently return null or fail on the UPDATE.
     */
    public static function addExperience(int|string $userId, int $pokemonId, int $xp): ?array
    {
        $entry = self::findEntry($userId, $pokemonId);
        if (!$entry) {
            return null;
        }

        $newXp = ($entry['experience'] ?? 0) + $xp;
        $newLevel = $entry['level'] ?? 1;

        // Simple XP curve: 100 XP per level
        $xpForNextLevel = $newLevel * 100;
        while ($newXp >= $xpForNextLevel) {
            $newXp -= $xpForNextLevel;
            $newLevel++;
            $xpForNextLevel = $newLevel * 100;
        }

        return self::updateComposite(
            ['user_id' => $entry['user_id'], 'pokemon_id' => $entry['pokemon_id']],
            [
                'level' => $newLevel,
                'experience' => $newXp
            ],
            true
        );
    }

    /**
     * Count total Pokémon types owned by a user (lightweight – only fetches pokemon_id)
     */
    public static function countByUser(int|string $userId): int
    {
        $instance = new static();
        $result = $instance->db->from(
            static::$table,
            'pokemon_id',
            ['user_id' => 'eq.' . $userId]
        );
        return count($result['data'] ?? []);
    }

    /**
     * Get Pokémon owned by a user – paginated.
     *
     * @param int|string $userId
     * @param int        $limit  Rows per page (max 100)
     * @param int        $offset Row offset
     */
    public static function getByUserIdPaginated(int|string $userId, int $limit = 20, int $offset = 0): array
    {
        $limit = min(100, max(1, $limit));
        $instance = new static();
        $result = $instance->db->from(
            static::$table,
            '*',
            ['user_id' => 'eq.' . $userId],
            $limit,
            $offset
        );
        return $result['data'] ?? [];
    }

    /**
     * Calculate total RPS (Revenue Per Second) for user's team
     */
    public static function calculateTotalRPS(int|string $userId): float
    {
        $userPokemon = self::getByUserId($userId);
        $totalRPS = 0.0;

        foreach ($userPokemon as $entry) {
            $pokemon = Pokemon::get($entry['pokemon_id']);
            if ($pokemon) {
                $level = $entry['level'] ?? 1;
                // RPS increases with level
                $totalRPS += $pokemon['production'] * (1 + ($level - 1) * 0.1);
            }
        }

        return round($totalRPS, 2);
    }
}
