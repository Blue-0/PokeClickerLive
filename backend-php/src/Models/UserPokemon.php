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
     * Add a Pokémon to user's inventory
     */
    public static function addPokemon(int|string $userId, int $pokemonId, ?float $lat = null, ?float $lng = null): ?array
    {
        $data = [
            'user_id' => $userId,
            'pokemon_id' => $pokemonId,
            'acquired_at' => date('c'),
            'level' => 1,
            'experience' => 0
        ];

        // Add GPS if provided
        if ($lat !== null && $lng !== null) {
            $data['latitude'] = $lat;
            $data['longitude'] = $lng;
        }

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
     * Count total Pokémon owned by a user
     */
    public static function countByUser(int|string $userId): int
    {
        $results = self::getByUserId($userId);
        return count($results);
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
