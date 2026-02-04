<?php
namespace App\Controllers\Admin;

use App\Controllers\Controller;
use App\Config\Database;
use PDO;

class PokemonController extends Controller
{
    public function index()
    {
        $pdo = Database::getInstance()->getConnection();

        // Fetch all Pokemon
        // We use schema public explicitly just in case, though default is usually public
        $stmt = $pdo->query("SELECT * FROM ref_pokemon ORDER BY id ASC");
        $pokemons = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Include View
        require __DIR__ . '/../../Views/admin_pokemon.php';
    }

    public function store()
    {
        // Simple form handling
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $name = $_POST['name'] ?? '';
            $base_cost = $_POST['base_cost'] ?? 0;
            $base_production = $_POST['base_production'] ?? 0;
            $rarity = $_POST['rarity'] ?? 'Common';
            $description = $_POST['description'] ?? '';

            if ($name && $base_cost) {
                $pdo = Database::getInstance()->getConnection();

                // Assuming ref_pokemon has columns: name, base_cost, base_production, rarity, description
                // Note: The schema in prompt mentions: ref_pokemon { id, name, description, base_cost, base_production, rarity, region_origin }
                // I will ignore region_origin for this simple form or add a default.

                $stmt = $pdo->prepare("INSERT INTO ref_pokemon (name, base_cost, base_production, rarity, description) VALUES (?, ?, ?, ?, ?)");
                try {
                    $stmt->execute([$name, $base_cost, $base_production, $rarity, $description]);
                } catch (\PDOException $e) {
                    // Simple error handling
                    die("Error inserting pokemon: " . $e->getMessage());
                }
            }
        }

        // Redirect back to index
        // Use relative path or absolute if known. /admin/pokemon matches the route I will define.
        header('Location: /admin/pokemon');
        exit;
    }
}
