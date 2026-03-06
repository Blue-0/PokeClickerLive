<?php
namespace App\Controllers\Admin;

use App\Controllers\Controller;
use App\Config\Supabase;

class PokemonController extends Controller
{
    public function index()
    {
        // Protect this page: only authenticated admins may access Pokémon management.
        $this->requireAdminBasicAuth();

        $supabase = Supabase::getInstance();
        $result = $supabase->from('ref_pokemon', '*');

        $pokemons = [];
        if (!isset($result['error']) && isset($result['data']) && is_array($result['data'])) {
            $pokemons = $result['data'];
            usort($pokemons, fn($a, $b) => ($a['id'] ?? 0) <=> ($b['id'] ?? 0));
        }

        $error = isset($result['error']) ? $result['error'] : null;

        // Generate CSRF token for the view
        $csrfToken = $this->generateCsrfToken();

        require __DIR__ . '/../../Views/admin_pokemon.php';
    }

    public function store()
    {
        // Protect this action: only authenticated admins may create Pokémon entries.
        $this->requireAdminBasicAuth();

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Verify CSRF Token
            if (!$this->validateCsrfToken()) {
                http_response_code(403);
                die('CSRF token validation failed.');
            }

            // Nettoyage rigoureux contre les failles XSS et filtres anti-injection
            $name = trim(htmlspecialchars($_POST['name'] ?? '', ENT_QUOTES, 'UTF-8'));
            $description = trim(htmlspecialchars($_POST['description'] ?? '', ENT_QUOTES, 'UTF-8'));
            
            // Validation stricte des types / valeurs (protection injection, intégrité)
            $base_cost = max(1, (int)($_POST['base_cost'] ?? 0));
            $base_production = max(1, (int)($_POST['base_production'] ?? 0));
            $allowed_rarities = ['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'];
            $rarity = in_array($_POST['rarity'] ?? '', $allowed_rarities) ? $_POST['rarity'] : 'Common';

            if ($name && $base_cost > 0) {
                $supabase = Supabase::getInstance();
                $supabase->insert('ref_pokemon', [
                    'name' => $name,
                    'base_cost' => $base_cost,
                    'base_production' => $base_production,
                    'rarity' => $rarity,
                    'description' => $description,
                ], true);
            }
        }

        header('Location: /admin/pokemon');
        exit;
    }
}
