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
     * Level up a user's Pokémon
     */
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
