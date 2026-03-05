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

    /**
     * POST /admin/api/users – Créer un nouvel utilisateur
     * Body JSON : { username: string, email: string, password: string }
     */
    public function createUser(): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $input = $this->getJsonInput() ?? [];
        $username = trim($input['username'] ?? '');
        $email    = trim($input['email']    ?? '');
        $password = $input['password']       ?? '';

        // Validation
        $errors = [];
        if (empty($username)) $errors[] = 'Le nom d\'utilisateur est requis';
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'Email invalide';
        if (strlen($password) < 6) $errors[] = 'Le mot de passe doit faire au moins 6 caractères';

        if (!empty($errors)) {
            http_response_code(400);
            echo json_encode(['error' => implode('. ', $errors)]);
            return;
        }

        $supabase = Supabase::getInstance();

        // Vérifier que l'email n'existe pas déjà
        $existing = $supabase->from('users', 'id', ['email' => 'eq.' . $email]);
        if (!empty($existing['data'])) {
            http_response_code(409);
            echo json_encode(['error' => 'Cet email est déjà utilisé']);
            return;
        }

        // Vérifier que le username n'existe pas déjà
        $existingUser = $supabase->from('users', 'id', ['username' => 'eq.' . $username]);
        if (!empty($existingUser['data'])) {
            http_response_code(409);
            echo json_encode(['error' => 'Ce nom d\'utilisateur est déjà pris']);
            return;
        }

        $data = [
            'username'          => $username,
            'email'             => $email,
            'password_hash'     => password_hash($password, PASSWORD_DEFAULT),
            'pokedollars'       => 0,
            'lifetime_earnings' => 0,
            'total_clicks'      => 0,
        ];

        $result = $supabase->insert('users', $data, true);

        if (isset($result['error']) || ($result['code'] ?? 0) >= 400) {
            http_response_code(500);
            echo json_encode(['error' => 'Échec de la création de l\'utilisateur']);
            return;
        }

        echo json_encode(['success' => true, 'user' => $result['data'][0] ?? $data]);
    }

    /**
     * POST /admin/api/users/{id}/profile – Modifier le profil d'un utilisateur
     * Body JSON : { username?: string, email?: string, password?: string }
     */
    public function updateUser(int $userId): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $input = $this->getJsonInput() ?? [];
        $data  = [];

        if (isset($input['username']) && trim($input['username']) !== '') {
            $data['username'] = trim($input['username']);
        }
        if (isset($input['email']) && filter_var(trim($input['email']), FILTER_VALIDATE_EMAIL)) {
            $data['email'] = trim($input['email']);
        }
        if (isset($input['password']) && strlen($input['password']) >= 6) {
            $data['password_hash'] = password_hash($input['password'], PASSWORD_DEFAULT);
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
            echo json_encode(['error' => 'Échec de la mise à jour du profil']);
            return;
        }

        echo json_encode(['success' => true, 'updated' => array_keys($data)]);
    }

    /**
     * POST /admin/api/users/{id}/delete – Supprimer un utilisateur et son inventaire
     */
    public function deleteUser(int $userId): void
    {
        $this->requireAdminJson();
        header('Content-Type: application/json');

        $supabase = Supabase::getInstance();

        // Supprimer d'abord l'inventaire de l'utilisateur
        $supabase->delete('user_pokemon', ['user_id' => 'eq.' . $userId], true);

        // Supprimer l'utilisateur
        $result = $supabase->delete('users', ['id' => 'eq.' . $userId], true);

        if (isset($result['error']) || ($result['code'] ?? 0) >= 400) {
            http_response_code(500);
            echo json_encode(['error' => 'Échec de la suppression de l\'utilisateur']);
            return;
        }

        echo json_encode(['success' => true, 'deleted_user_id' => $userId]);
    }
}
