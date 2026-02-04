<?php
namespace App\Controllers\Admin;

use App\Models\PokemonModel;

class PokemonController {

    public function index() {
        $model = new PokemonModel();
        $pokemons = $model->getAll();

        // Simple view rendering
        require __DIR__ . '/../../Views/Admin/pokemon_list.php';
    }

    public function create() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $model = new PokemonModel();

            $name = $_POST['name'] ?? '';
            $base_cost = $_POST['base_cost'] ?? 0;
            $rarity = $_POST['rarity'] ?? 'Common';
            // Optional/Default fields for the example
            $description = $_POST['description'] ?? '';
            $base_production = $_POST['base_production'] ?? 0;
            $region_origin = $_POST['region_origin'] ?? 'Kanto';

            if (!empty($name) && $base_cost > 0) {
                $model->create($name, $description, $base_cost, $base_production, $rarity, $region_origin);
                // Redirect to list to prevent resubmission
                header('Location: /admin/pokemon');
                exit;
            } else {
                $error = "Name and Base Cost are required.";
                $pokemons = $model->getAll(); // Need data to re-render list
                require __DIR__ . '/../../Views/Admin/pokemon_list.php';
            }
        }
    }
}
