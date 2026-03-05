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
     * POST /api/user/capture
     * Register a single wild-capture immediately so it is persisted even if
     * the player closes the app before the next periodic sync.
     * Body: { "pokemon_id": int }
     */
    public function capture(): void
    {
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        $userId = $payload['user_id'];
        $input  = $this->getJsonInput();

        if (!$input || !isset($input['pokemon_id'])) {
            $this->error('pokemon_id is required', 400);
            return;
        }

        $pokemonId = (int) $input['pokemon_id'];
        if ($pokemonId <= 0) {
            $this->error('Invalid pokemon_id', 400);
            return;
        }

        // Best-effort: ensure ref_pokemon row exists for FK but don't block on failure.
        // The row likely already exists from a previous sync. If ensureInDb fails and
        // the FK constraint is violated, addPokemon will return null (logged below).
        Pokemon::ensureInDb($pokemonId);

        // addPokemon incrémente la quantité si l'entrée existe déjà,
        // ou crée une nouvelle ligne avec quantity=1 sinon.
        $entry = UserPokemon::addPokemon($userId, $pokemonId);

        error_log("CAPTURE: userId=$userId pokemon=$pokemonId entry=" . json_encode($entry));

        if ($entry === null) {
            // Log the failure but return 200 so the Flutter retry logic
            // does not loop — the periodic sync will recover the miss.
            error_log("CAPTURE: addPokemon returned null for userId=$userId pokemon=$pokemonId");
        }

        $this->success([
            'pokemon_id' => $pokemonId,
            'entry'      => $entry,
        ]);
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
     *
     * Algorithme :
     * 1. Récupérer le last_sync de l'utilisateur (timestamp serveur du dernier sync).
     * 2. Pour chaque entrée de la collection Flutter, comparer son champ acquiredAt
     *    avec last_sync :
     *    - acquiredAt > last_sync  → nouvelle capture depuis le dernier sync
     *      → appeler addPokemon() pour incrémenter la quantité en DB.
     *    - acquiredAt <= last_sync → entrée restaurée depuis le cloud ou ancienne
     *      → appeler syncQuantity() (idempotent, protège contre la perte de données).
     * 3. Si last_sync est absent (premier sync), tout le monde est traité comme
     *    restauré (syncQuantity) pour éviter les doublons.
     *
     * Cette approche permet au sync de rattraper les captures manquées par
     * registerCapture (réseau coupé, erreur FK, etc.).
     */
    private function syncPokemonCollection($userId, array $collection): void
    {
        // Récupérer le last_sync de l'utilisateur pour distinguer nouvelles captures
        $user = User::find($userId);
        $lastSyncTs = 0;
        if ($user && !empty($user['last_sync'])) {
            $lastSyncTs = strtotime($user['last_sync']) ?: 0;
        }

        // Regrouper par pokemonId : total et nouvelles captures
        $totals      = []; // pokemonId => nombre total d'entrées côté client
        $newCaptures = []; // pokemonId => nouvelles captures depuis last_sync

        foreach ($collection as $pokemon) {
            $pId = $pokemon['pokemonId'] ?? null;
            if (!$pId || !is_numeric($pId)) {
                error_log("SYNC: Skipping pokemon with no numeric pokemonId: " . json_encode($pokemon));
                continue;
            }

            $pokemonId = (int) $pId;
            $totals[$pokemonId] = ($totals[$pokemonId] ?? 0) + 1;

            // Détecter si l'entrée est une nouvelle capture
            if ($lastSyncTs > 0 && isset($pokemon['acquiredAt'])) {
                $acquiredTs = strtotime($pokemon['acquiredAt']) ?: 0;
                if ($acquiredTs > $lastSyncTs) {
                    $newCaptures[$pokemonId] = ($newCaptures[$pokemonId] ?? 0) + 1;
                }
            }
        }

        error_log("SYNC: collection totals = " . json_encode($totals));
        error_log("SYNC: new captures since last_sync = " . json_encode($newCaptures));

        foreach ($totals as $pokemonId => $totalQty) {
            if (!Pokemon::ensureInDb($pokemonId)) {
                error_log("SYNC: Could not ensure ref_pokemon for $pokemonId, skipping");
                continue;
            }

            $newQty = $newCaptures[$pokemonId] ?? 0;

            if ($newQty > 0) {
                // Appliquer les nouvelles captures comme incréments en DB.
                // Cela rattrape les registerCapture() qui auraient échoué côté réseau.
                for ($i = 0; $i < $newQty; $i++) {
                    UserPokemon::addPokemon($userId, $pokemonId);
                }
                error_log("SYNC: addPokemon x{$newQty} for pokemon=$pokemonId (new captures)");
            }

            // Toujours appeler syncQuantity pour s'assurer que la ligne existe
            // et que la quantité serveur n'est pas inférieure au total client.
            $result = UserPokemon::syncQuantity($userId, $pokemonId, $totalQty);
            error_log("SYNC: syncQuantity pokemon=$pokemonId totalQty=$totalQty result=" . json_encode($result));
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
