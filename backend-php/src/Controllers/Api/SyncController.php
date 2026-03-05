<?php
namespace App\Controllers\Api;

use App\Controllers\Controller;
use App\Models\User;
use App\Models\UserPokemon;
use App\Models\Pokemon;
use App\Models\TransactionLog;
use App\Utils\JWT;

/**
 * Sync Controller
 * Handles synchronization of game progress between client and server
 */
class SyncController extends Controller
{
    /**
     * POST /api/user/sync
     * Sync local progress with the cloud
     */
    public function sync(): void
    {
        // 1. Auth Check
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        $userId = $payload['user_id'];
        $input = $this->getJsonInput();

        // Debug: Log what we received
        error_log("SYNC: userId = " . json_encode($userId));
        error_log("SYNC: input = " . json_encode($input));

        if (!$input || !isset($input['local_data'])) {
            $this->error('Invalid sync data - missing local_data', 400);
            return;
        }

        $localData = $input['local_data'];
        $lat = isset($input['latitude']) ? (float) $input['latitude'] : null;
        $lng = isset($input['longitude']) ? (float) $input['longitude'] : null;

        try {
            $updateResult = null;

            // 2. Update user stats from clicker data
            if (isset($localData['clicker'])) {
                $clickerData = $localData['clicker'];
                $updateResult = $this->updateUserStats($userId, $clickerData, $lat, $lng, $localData);
                error_log("SYNC: updateUserStats result = " . json_encode($updateResult));
            }

            // 3. Sync Pokemon collection
            if (isset($localData['collection']) && is_array($localData['collection'])) {
                $this->syncPokemonCollection($userId, $localData['collection']);
            }

            // 4. Get current cloud data
            $cloudData = $this->getCloudData($userId);

            // Debug info is intentionally kept server-side (error_log) only,
            // never exposed to the client response.
            $this->success([
                'server_timestamp' => time(),
                'cloud_data'       => $cloudData,
            ]);

        } catch (\Exception $e) {
            error_log("SYNC ERROR: " . $e->getMessage());
            // Do not expose internal error details to the client
            $this->error('Sync failed', 500);
        }
    }

    /**
     * GET /api/user/load
     * Load cloud save data without modifying server state (read-only restore)
     */
    public function load(): void
    {
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        $userId = $payload['user_id'];

        try {
            $cloudData = $this->getCloudData($userId);
            $this->success(['cloud_data' => $cloudData]);
        } catch (\Exception $e) {
            error_log("LOAD ERROR: " . $e->getMessage());
            $this->error('Load failed', 500);
        }
    }

    /**
     * Update user stats (currency, clicks, etc.) and persist full game state
     * Returns the update result for debugging
     */
    private function updateUserStats($userId, array $clickerData, ?float $lat = null, ?float $lng = null, array $localData = []): ?array
    {
        $updateData = [
            'last_sync' => date('c')
        ];

        // Add GPS if provided
        if ($lat !== null && $lng !== null) {
            $updateData['latitude'] = $lat;
            $updateData['longitude'] = $lng;
        }

        $user = User::find($userId);
        error_log("SYNC: Found user = " . json_encode($user ? 'yes' : 'no'));

        // Update pokedollars
        if (isset($clickerData['currency'])) {
            $clientCurrency = (int) $clickerData['currency'];
            $serverPokedollars = $user ? (int)($user['pokedollars'] ?? 0) : 0;
            
            $previousGameState = null;
            if ($user && isset($user['game_state'])) {
                $previousGameState = is_string($user['game_state']) ? json_decode($user['game_state'], true) : $user['game_state'];
            }
            $previousClientCurrency = isset($previousGameState['clicker']['currency']) ? (int)$previousGameState['clicker']['currency'] : 0;
            
            // Calcul de la différence depuis le dernier Sync
            $clientDelta = $clientCurrency - $previousClientCurrency;
            
            // On applique la différence au solde serveur (qui gagne sur les suppressions)
            $newPokedollars = max(0, $serverPokedollars + $clientDelta);
            
            $updateData['pokedollars'] = $newPokedollars;
            
            // Mise à jour de ce qu'on va sauvegarder en JSON de l'état du jeu pour la prochaine fois
            $localData['clicker']['currency'] = $newPokedollars;
            $clickerData['currency'] = $newPokedollars;

            if ($user && $clientDelta > 0) {
                $updateData['lifetime_earnings'] = ($user['lifetime_earnings'] ?? 0) + $clientDelta;
                TransactionLog::log($userId, 'earn', $clientDelta, 'Game sync earnings', $lat, $lng);
            }
        }

        // Update total clicks (increment based on level as proxy)
        if (isset($clickerData['level'])) {
            $user = $user ?? User::find($userId);
            if ($user) {
                $currentClicks = $user['total_clicks'] ?? 0;
                $newLevel = (int) $clickerData['level'];
                $updateData['total_clicks'] = max($currentClicks, $newLevel);
            }
        }

        // Persist full game state for cloud restore.
        // Only save if the state is non-trivial (player has made real progress)
        // to avoid overwriting a good save with empty defaults after login.
        $currency = (int) ($clickerData['currency'] ?? 0);
        $level    = (int) ($clickerData['level'] ?? 1);
        $hasCollection = !empty($localData['collection']);
        $hasShop = !empty($localData['shop']);
        $hasPrestige = !empty($localData['prestige']) && ($localData['prestige']['level'] ?? 0) > 0;

        if ($currency > 0 || $level > 1 || $hasCollection || $hasShop || $hasPrestige) {
            $updateData['game_state'] = $localData;
        }

        error_log("SYNC: updateData = " . json_encode($updateData));

        $result = User::update($userId, $updateData, true);
        error_log("SYNC: User::update result = " . json_encode($result));

        return $result;
    }

    /**
     * Sync Pokemon collection.
     * addPokemon() already handles the upsert logic (insert-or-increment),
     * so we call it directly without a prior findEntry check — saves one
     * DB roundtrip per Pokémon.
     */
    private function syncPokemonCollection($userId, array $collection): void
    {
        foreach ($collection as $pokemon) {
            // Check for pokemonId first (Flutter model), fallback to id if not present
            $pId = $pokemon['pokemonId'] ?? $pokemon['id'] ?? null;

            if (!$pId) {
                error_log("SYNC: Skipping pokemon with no ID: " . json_encode($pokemon));
                continue;
            }

            $pokemonId = (int) $pId;

            // Ensure the ref_pokemon row exists (PokeAPI data → DB) so FK is satisfied
            if (!Pokemon::ensureInDb($pokemonId)) {
                error_log("SYNC: Could not ensure ref_pokemon for $pokemonId, skipping");
                continue;
            }

            // ensureExists is idempotent: creates row if missing, no-op if present.
            // addPokemon would increment quantity on every sync, which is wrong.
            $result = UserPokemon::ensureExists($userId, $pokemonId);
            error_log("SYNC: ensureExists pokemon $pokemonId result = " . json_encode($result));
        }
    }

    /**
     * Get all cloud data for the user
     */
    private function getCloudData($userId): array
    {
        $user = User::find($userId);
        $pokemon = UserPokemon::getByUserId($userId);

        // Parse game_state JSON if stored as a string
        $gameState = $user['game_state'] ?? null;
        if (is_string($gameState)) {
            $gameState = json_decode($gameState, true);
        }

        return [
            'user' => $user ? [
                'pokedollars' => $user['pokedollars'] ?? 0,
                'lifetime_earnings' => $user['lifetime_earnings'] ?? 0,
                'total_clicks' => $user['total_clicks'] ?? 0,
            ] : null,
            'pokemon'    => $pokemon,
            'last_sync'  => $user['last_sync'] ?? null,
            'game_state' => $gameState,
        ];
    }
}
