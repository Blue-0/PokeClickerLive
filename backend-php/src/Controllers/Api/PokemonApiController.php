<?php
namespace App\Controllers\Api;

use App\Controllers\Controller;
use App\Models\Pokemon;
use App\Models\User;
use App\Models\UserPokemon;
use App\Models\TransactionLog;
use App\Utils\JWT;

/**
 * Pokemon API Controller
 * Handles all Pokémon-related API endpoints
 */
class PokemonApiController extends Controller
{
    /**
     * GET /api/pokemon
     * List Pokémon (paginated)
     */
    public function index(): void
    {
        $offset = isset($_GET['offset']) ? (int) $_GET['offset'] : 0;
        $limit = isset($_GET['limit']) ? min((int) $_GET['limit'], 50) : 20;

        $pokemon = Pokemon::getRange($offset, $limit);

        $this->success([
            'pokemon' => $pokemon,
            'offset' => $offset,
            'limit' => $limit,
            'total' => Pokemon::SINNOH_END - Pokemon::SINNOH_START + 1
        ]);
    }

    /**
     * GET /api/pokemon/{id}
     * Get a single Pokémon by ID
     */
    public function show(string $id = ''): void
    {
        if (empty($id)) {
            $this->error('Pokemon ID required', 400);
            return;
        }

        $pokemon = Pokemon::get((int) $id);

        if (!$pokemon) {
            $this->error('Pokemon not found', 404);
            return;
        }

        $this->success($pokemon);
    }

    /**
     * POST /api/pokemon/catch
     * Catch/buy a Pokémon for the authenticated user
     * Body: { "pokemon_id": int, "latitude"?: float, "longitude"?: float }
     */
    public function catch(): void
    {
        // 1. Auth Check
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }
        $userId = $payload['user_id'];

        $input = $this->getJsonInput();

        if (!$input || !isset($input['pokemon_id'])) {
            $this->error('pokemon_id is required', 400);
            return;
        }

        $pokemonId = (int) $input['pokemon_id'];
        $lat = $input['latitude'] ?? null;
        $lng = $input['longitude'] ?? null;

        // Get Pokémon data
        $pokemon = Pokemon::get($pokemonId);
        if (!$pokemon) {
            $this->error('Pokemon not found', 404);
            return;
        }

        // Get user
        $user = User::find($userId);
        if (!$user) {
            $this->error('User not found', 404);
            return;
        }

        // Check balance
        $price = $pokemon['price'];
        if (($user['pokedollars'] ?? 0) < $price) {
            $this->error('Insufficient balance. Need ₽' . $price, 402);
            return;
        }

        // Deduct balance
        User::updateBalance($userId, -$price);

        // Add Pokémon to inventory
        $entry = UserPokemon::addPokemon($userId, $pokemonId, $lat, $lng);

        // Log transaction
        TransactionLog::logCatch($userId, $pokemonId, $price, $lat, $lng);

        $this->success([
            'message' => 'Caught ' . $pokemon['name'] . '!',
            'pokemon' => $pokemon,
            'entry' => $entry,
            'new_balance' => ($user['pokedollars'] ?? 0) - $price
        ]);
    }

    /**
     * GET /api/user/{id}/pokemon
     * Get all Pokémon owned by the authenticated user.
     * A user can only access their own collection (JWT user_id must match {id}).
     */
    public function userPokemon(string $userId = ''): void
    {
        if (empty($userId)) {
            $this->error('User ID required', 400);
            return;
        }

        // Auth check: valid JWT required
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        // Ownership check: the authenticated user may only read their own collection.
        // Use loose comparison because the URL parameter is a string and the JWT
        // user_id may be an integer depending on the DB driver.
        if ((string) $payload['user_id'] !== (string) $userId) {
            $this->error('Forbidden – you can only access your own collection', 403);
            return;
        }

        $entries = UserPokemon::getByUserId($userId);

        // Enrich with Pokémon data
        $pokemon = [];
        foreach ($entries as $entry) {
            $pData = Pokemon::get($entry['pokemon_id']);
            if ($pData) {
                $pokemon[] = array_merge($entry, ['pokemon' => $pData]);
            }
        }

        $this->success([
            'count' => count($pokemon),
            'total_rps' => UserPokemon::calculateTotalRPS($userId),
            'pokemon' => $pokemon
        ]);
    }
}
