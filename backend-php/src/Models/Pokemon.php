<?php
namespace App\Models;

/**
 * Pokemon Model
 * Fetches Pokémon data from PokéAPI with local JSON cache
 */
class Pokemon extends Model
{
    protected static string $table = 'ref_pokemon'; // For any local overrides
    private static string $cacheDir = __DIR__ . '/../../cache/pokemon/';
    private static string $apiUrl = 'https://pokeapi.co/api/v2/pokemon/';

    // Sinnoh region Pokémon IDs (387-493)
    public const SINNOH_START = 387;
    public const SINNOH_END = 493;

    /**
     * Get a Pokémon by ID (cache or API)
     */
    public static function get(int $id): ?array
    {
        // Try cache first
        $cached = self::getFromCache($id);
        if ($cached) {
            return self::formatPokemon($cached);
        }

        // Fetch from PokéAPI
        $data = self::fetchFromApi($id);
        if ($data) {
            self::saveToCache($id, $data);
            return self::formatPokemon($data);
        }

        return null;
    }

    /**
     * Get multiple Pokémon (paginated)
     */
    public static function getRange(int $offset = 0, int $limit = 20): array
    {
        $pokemon = [];
        $start = self::SINNOH_START + $offset;
        $end = min($start + $limit, self::SINNOH_END + 1);

        for ($i = $start; $i < $end; $i++) {
            $p = self::get($i);
            if ($p) {
                $pokemon[] = $p;
            }
        }

        return $pokemon;
    }

    /**
     * Format Pokémon data with game rules (price, production)
     */
    private static function formatPokemon(array $data): array
    {
        $baseExp = $data['base_experience'] ?? 100;
        $attack = $data['stats'][1]['base_stat'] ?? 50; // Attack stat

        return [
            'id' => $data['id'],
            'name' => ucfirst($data['name']),
            'sprite' => $data['sprites']['front_default'] ?? null,
            'sprite_shiny' => $data['sprites']['front_shiny'] ?? null,
            'types' => array_map(fn($t) => $t['type']['name'], $data['types'] ?? []),
            // Game mechanics (from specs)
            'price' => $baseExp * 15,
            'production' => round($attack / 10, 2), // RPS (Revenue Per Second)
            'base_experience' => $baseExp
        ];
    }

    /**
     * Get Pokémon from local cache
     */
    private static function getFromCache(int $id): ?array
    {
        $file = self::$cacheDir . $id . '.json';
        if (file_exists($file)) {
            $content = file_get_contents($file);
            return json_decode($content, true);
        }
        return null;
    }

    /**
     * Save Pokémon to local cache
     */
    private static function saveToCache(int $id, array $data): void
    {
        if (!is_dir(self::$cacheDir)) {
            mkdir(self::$cacheDir, 0755, true);
        }

        $file = self::$cacheDir . $id . '.json';
        file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT));
    }

    /**
     * Fetch Pokémon from PokéAPI
     */
    private static function fetchFromApi(int $id): ?array
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, self::$apiUrl . $id);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        curl_setopt($ch, CURLOPT_USERAGENT, 'PokeClicker/1.0');

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            return json_decode($response, true);
        }

        return null;
    }

    /**
     * Ensure a Pokémon row exists in the ref_pokemon DB table.
     * Fetches data from PokeAPI/cache and inserts a minimal row if missing.
     * This is required because user_pokemon.pokemon_id has a FK to ref_pokemon.id.
     */
    public static function ensureInDb(int $id): bool
    {
        // Check if already in DB
        $instance = new static();
        $result = $instance->db->from(static::$table, 'id', ['id' => 'eq.' . $id]);
        if (!empty($result['data'])) {
            return true; // Already exists
        }

        // Get data from PokeAPI / cache
        $apiData = self::get($id);
        if (!$apiData) {
            error_log("Pokemon::ensureInDb: Could not fetch pokemon $id from API");
            return false;
        }

        $row = [
            'id'              => $id,
            'name'            => $apiData['name'] ?? 'Unknown',
            'description'     => '',
            'base_cost'       => $apiData['price'] ?? 0,
            'base_production' => $apiData['production'] ?? 0,
            'rarity'          => 'common',
            'sprite_asset'    => $apiData['sprite'] ?? '/assets/pokemon/unknown.png',
            'region_origin'   => 'Sinnoh',
            'created_at'      => date('c'),
        ];

        $insertResult = $instance->db->insert(static::$table, $row, true);

        if (isset($insertResult['error']) || ($insertResult['code'] ?? 0) >= 400) {
            // Could be a race condition (another request inserted it) – check for 409 conflict
            if (($insertResult['code'] ?? 0) === 409) {
                return true; // Already exists now
            }
            error_log("Pokemon::ensureInDb: insert failed for $id: " . json_encode($insertResult));
            return false;
        }

        return true;
    }

    /**
     * Clear the cache for a specific Pokémon or all
     */
    public static function clearCache(?int $id = null): void
    {
        if ($id) {
            $file = self::$cacheDir . $id . '.json';
            if (file_exists($file)) {
                unlink($file);
            }
        } else {
            $files = glob(self::$cacheDir . '*.json');
            foreach ($files as $file) {
                unlink($file);
            }
        }
    }
}
