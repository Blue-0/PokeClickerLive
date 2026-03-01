<?php
namespace App\Controllers\Admin;

use App\Controllers\Controller;
use App\Config\Supabase;

class UsersController extends Controller
{
    /**
     * Vérifie l'authentification admin et envoie une réponse JSON 401 si refusé.
     * Utilisé pour les endpoints AJAX/API (/admin/api/*).
     *
     * Priorité :
     *  1. Cookie de session créé par requireAdminBasicAuth() (navigation HTML initiale).
     *     fetch({ credentials: 'include' }) envoie ce cookie automatiquement.
     *  2. Header Authorization: Basic (client API ou premier appel direct).
     */
    private function requireAdminJson(): void
    {
        // ── 1. Vérification par session ───────────────────────────────────
        if (session_status() === PHP_SESSION_NONE) {
            session_name('admin_session');
            session_start();
        }
        if (!empty($_SESSION['admin_authenticated'])) {
            return;
        }

        // ── 2. Vérification par header Basic Auth (fallback) ─────────────
        $authUser     = $_SERVER['PHP_AUTH_USER'] ?? '';
        $authPass     = $_SERVER['PHP_AUTH_PW']   ?? '';
        $expectedUser = getenv('ADMIN_USER')          ?: 'admin';
        $expectedHash = getenv('ADMIN_PASSWORD_HASH') ?: '';

        $authorized = $expectedHash
            && $authUser === $expectedUser
            && password_verify($authPass, $expectedHash);

        if (!$authorized) {
            header('WWW-Authenticate: Basic realm="Sinnoh Clicker Admin"');
            http_response_code(401);
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Non autorisé']);
            exit;
        }

        // Mémoriser pour les prochains appels de cette session
        $_SESSION['admin_authenticated'] = true;
    }

    /**
     * GET /admin/users – Page HTML de gestion des utilisateurs
     */
    public function index(): void
    {
        $this->requireAdminBasicAuth();

        $supabase = Supabase::getInstance();
        $result   = $supabase->from(
            'users',
            'id,username,email,pokedollars,lifetime_earnings,total_clicks,last_sync,created_at'
        );

        $users = [];
        if (!isset($result['error']) && is_array($result['data'] ?? null)) {
            $users = $result['data'];
            usort($users, fn($a, $b) => ($a['id'] ?? 0) <=> ($b['id'] ?? 0));
        }

        require __DIR__ . '/../../Views/admin_users.php';
    }

    /**
     * GET /admin/api/users – Liste JSON de tous les utilisateurs avec leurs stats
     */
    public function apiUsers(): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $supabase = Supabase::getInstance();
        $result   = $supabase->from(
            'users',
            'id,username,email,pokedollars,lifetime_earnings,total_clicks,last_sync,created_at'
        );

        if (isset($result['error'])) {
            http_response_code(500);
            echo json_encode(['error' => $result['error']]);
            return;
        }

        $users = $result['data'] ?? [];
        usort($users, fn($a, $b) => ($a['id'] ?? 0) <=> ($b['id'] ?? 0));

        echo json_encode(['users' => $users, 'timestamp' => date('c')]);
    }

    /**
     * GET /admin/api/users/{id}/inventory – Inventaire JSON d'un utilisateur,
     * enrichi avec les données de ref_pokemon
     */
    public function apiInventory(int $userId): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $supabase  = Supabase::getInstance();
        $invResult = $supabase->from(
            'user_pokemon',
            'pokemon_id,quantity,level,experience,acquired_at',
            ['user_id' => 'eq.' . $userId]
        );

        if (isset($invResult['error'])) {
            http_response_code(500);
            echo json_encode(['error' => $invResult['error']]);
            return;
        }

        $inventory = $invResult['data'] ?? [];

        // Enrichissement avec les données ref_pokemon
        $pokeResult = $supabase->from('ref_pokemon', 'id,name,rarity,base_production,base_cost');
        $pokeMap    = [];
        if (!isset($pokeResult['error']) && is_array($pokeResult['data'] ?? null)) {
            foreach ($pokeResult['data'] as $p) {
                $pokeMap[(int)($p['id'] ?? 0)] = $p;
            }
        }

        foreach ($inventory as &$item) {
            $item['pokemon'] = $pokeMap[(int)($item['pokemon_id'] ?? 0)] ?? null;
        }
        unset($item);

        echo json_encode([
            'inventory' => $inventory,
            'user_id'   => $userId,
            'timestamp' => date('c'),
        ]);
    }

    /**
     * POST /admin/api/users/{id}/stats – Met à jour les statistiques d'un utilisateur
     * Body JSON : { pokedollars?: int, lifetime_earnings?: int, total_clicks?: int }
     */
    public function updateStats(int $userId): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $input   = $this->getJsonInput() ?? [];
        $allowed = ['pokedollars', 'lifetime_earnings', 'total_clicks'];
        $data    = [];

        foreach ($allowed as $field) {
            if (isset($input[$field]) && is_numeric($input[$field])) {
                $data[$field] = max(0, (int)$input[$field]);
            }
        }

        if (empty($data)) {
            http_response_code(400);
            echo json_encode(['error' => 'Aucun champ valide fourni']);
            return;
        }

        $supabase = Supabase::getInstance();
        $result   = $supabase->update('users', $data, ['id' => 'eq.' . $userId], true);

        if (isset($result['error']) || ($result['code'] ?? 0) >= 400) {
            http_response_code(500);
            echo json_encode(['error' => 'Échec de la mise à jour des statistiques']);
            return;
        }

        echo json_encode(['success' => true, 'updated' => $data]);
    }

    /**
     * POST /admin/api/users/{id}/inventory – Met à jour ou supprime une entrée d'inventaire
     * Body JSON : { pokemon_id: int, action: "update"|"delete", level?: int, experience?: int, quantity?: int }
     */
    public function updateInventory(int $userId): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $input     = $this->getJsonInput() ?? [];
        $pokemonId = (int)($input['pokemon_id'] ?? 0);
        $action    = in_array($input['action'] ?? '', ['update', 'delete'], true)
            ? $input['action']
            : 'update';

        if (!$pokemonId) {
            http_response_code(400);
            echo json_encode(['error' => 'pokemon_id requis']);
            return;
        }

        $supabase = Supabase::getInstance();
        $filters  = [
            'user_id'    => 'eq.' . $userId,
            'pokemon_id' => 'eq.' . $pokemonId,
        ];

        if ($action === 'delete') {
            $supabase->delete('user_pokemon', $filters, true);
            echo json_encode(['success' => true, 'action' => 'deleted']);
            return;
        }

        // Mise à jour
        $allowed = ['level', 'experience', 'quantity'];
        $data    = [];
        foreach ($allowed as $field) {
            if (isset($input[$field]) && is_numeric($input[$field])) {
                $data[$field] = max(0, (int)$input[$field]);
            }
        }

        if (empty($data)) {
            http_response_code(400);
            echo json_encode(['error' => 'Aucun champ valide fourni']);
            return;
        }

        $result = $supabase->update('user_pokemon', $data, $filters, true);

        if (isset($result['error']) || ($result['code'] ?? 0) >= 400) {
            http_response_code(500);
            echo json_encode(['error' => 'Échec de la mise à jour de l\'inventaire']);
            return;
        }

        echo json_encode(['success' => true, 'updated' => $data]);
    }
}
