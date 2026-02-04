<?php
namespace App\Models;

use App\Utils\Database;
use PDO;

class PokemonModel {
    private $pdo;

    public function __construct() {
        $this->pdo = Database::getConnection();
    }

    public function getAll() {
        $stmt = $this->pdo->query("SELECT * FROM ref_pokemon ORDER BY id ASC");
        return $stmt->fetchAll();
    }

    public function create($name, $description, $base_cost, $base_production, $rarity, $region_origin) {
        $sql = "INSERT INTO ref_pokemon (name, description, base_cost, base_production, rarity, region_origin)
                VALUES (:name, :description, :base_cost, :base_production, :rarity, :region_origin)";

        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([
            ':name' => $name,
            ':description' => $description,
            ':base_cost' => $base_cost,
            ':base_production' => $base_production,
            ':rarity' => $rarity,
            ':region_origin' => $region_origin
        ]);
    }
}
