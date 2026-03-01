<?php
namespace App\Controllers\Api;

use App\Controllers\Controller;
use App\Models\User;
use App\Models\UserPokemon;
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
                $updateResult = $this->updateUserStats($userId, $clickerData, $lat, $lng);
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
     * Update user stats (currency, clicks, etc.)
     * Returns the update result for debugging
     */
    private function updateUserStats($userId, array $clickerData, ?float $lat = null, ?float $lng = null): ?array
    {
        $updateData = [
            'last_sync' => date('c')
        ];

        // Add GPS if provided
        if ($lat !== null && $lng !== null) {
            $updateData['latitude'] = $lat;
            $updateData['longitude'] = $lng;
        }

        // Update pokedollars
        if (isset($clickerData['currency'])) {
            $currency = (int) $clickerData['currency'];
            $updateData['pokedollars'] = $currency;

            // Update lifetime earnings if current is higher
            $user = User::find($userId);
            error_log("SYNC: Found user = " . json_encode($user ? 'yes' : 'no'));

            if ($user && $currency > ($user['pokedollars'] ?? 0)) {
                $difference = $currency - ($user['pokedollars'] ?? 0);
                if ($difference > 0) {
                    $updateData['lifetime_earnings'] = ($user['lifetime_earnings'] ?? 0) + $difference;

                    // Log the transaction with GPS
                    TransactionLog::log($userId, 'earn', $difference, 'Game sync earnings', $lat, $lng);
                }
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

        error_log("SYNC: updateData = " . json_encode($updateData));

        $result = User::update($userId, $updateData, true);
        error_log("SYNC: User::update result = " . json_encode($result));

        return $result;
    }

    /**
     * Sync Pokemon collection
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

            // Check if user already has this Pokemon
            $existing = UserPokemon::findEntry($userId, $pokemonId);

            if (!$existing) {
                // Add new Pokemon to collection
                $result = UserPokemon::addPokemon($userId, $pokemonId);
                error_log("SYNC: Added pokemon $pokemonId result = " . json_encode($result));
            }
        }
    }

    /**
     * Get all cloud data for the user
     */
    private function getCloudData($userId): array
    {
        $user = User::find($userId);
        $pokemon = UserPokemon::getByUserId($userId);

        return [
            'user' => $user ? [
                'pokedollars' => $user['pokedollars'] ?? 0,
                'lifetime_earnings' => $user['lifetime_earnings'] ?? 0,
                'total_clicks' => $user['total_clicks'] ?? 0,
            ] : null,
            'pokemon' => $pokemon,
            'last_sync' => $user['last_sync'] ?? null
        ];
    }
}
