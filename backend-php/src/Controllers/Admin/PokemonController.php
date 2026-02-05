<?php
namespace App\Controllers\Admin;

use App\Controllers\Controller;
use App\Config\Supabase;

class PokemonController extends Controller
{
    public function index()
    {
        $supabase = Supabase::getInstance();
        $result = $supabase->from('ref_pokemon', '*');

        $pokemons = [];
        if (!isset($result['error']) && isset($result['data']) && is_array($result['data'])) {
            $pokemons = $result['data'];
            usort($pokemons, fn($a, $b) => ($a['id'] ?? 0) <=> ($b['id'] ?? 0));
        }

        $error = isset($result['error']) ? $result['error'] : null;

        require __DIR__ . '/../../Views/admin_pokemon.php';
    }

    public function store()
    {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $name = $_POST['name'] ?? '';
            $base_cost = (int)($_POST['base_cost'] ?? 0);
            $base_production = (int)($_POST['base_production'] ?? 0);
            $rarity = $_POST['rarity'] ?? 'Common';
            $description = $_POST['description'] ?? '';

            if ($name && $base_cost) {
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
