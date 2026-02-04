<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Gestion Pokémon</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; padding: 20px; line-height: 1.6; color: #333; }
        h1, h3 { color: #2c3e50; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f1f1f1; }
        .card { background: #fff; padding: 20px; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .form-row { display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 15px; }
        .form-group { flex: 1; min-width: 200px; display: flex; flex-direction: column; }
        label { margin-bottom: 5px; font-weight: 500; }
        input, select, textarea { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; transition: background 0.2s; }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h1>Administration - Sinnoh Clicker</h1>

    <div class="card">
        <h3>Ajouter un Nouveau Pokémon</h3>
        <form action="/admin/pokemon" method="POST">
            <div class="form-row">
                <div class="form-group">
                    <label>Nom du Pokémon</label>
                    <input type="text" name="name" required placeholder="Ex: Pikachu">
                </div>
                <div class="form-group">
                    <label>Rareté</label>
                    <select name="rarity">
                        <option value="Common">Common</option>
                        <option value="Uncommon">Uncommon</option>
                        <option value="Rare">Rare</option>
                        <option value="Epic">Epic</option>
                        <option value="Legendary">Legendary</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Coût de Base (Pokédollars)</label>
                    <input type="number" name="base_cost" required placeholder="100">
                </div>
                <div class="form-group">
                    <label>Production de Base (Click/s)</label>
                    <input type="number" name="base_production" required placeholder="10">
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label>Description</label>
                <textarea name="description" rows="3" placeholder="Description du Pokémon..."></textarea>
            </div>

            <button type="submit">Ajouter à la base de données</button>
        </form>
    </div>

    <div class="card">
        <h3>Inventaire de Référence (ref_pokemon)</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Coût Base</th>
                    <th>Prod Base</th>
                    <th>Rareté</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <?php if (empty($pokemons)): ?>
                <tr>
                    <td colspan="6" style="text-align: center;">Aucun Pokémon trouvé.</td>
                </tr>
                <?php else: ?>
                    <?php foreach ($pokemons as $p): ?>
                    <tr>
                        <td><?= htmlspecialchars($p['id'] ?? '') ?></td>
                        <td><?= htmlspecialchars($p['name'] ?? '') ?></td>
                        <td><?= number_format($p['base_cost'] ?? 0) ?> $</td>
                        <td><?= htmlspecialchars($p['base_production'] ?? 0) ?></td>
                        <td>
                            <span style="
                                padding: 2px 8px;
                                border-radius: 10px;
                                font-size: 12px;
                                background-color: <?= ($p['rarity'] == 'Legendary') ? '#ffd700' : (($p['rarity'] == 'Rare') ? '#add8e6' : '#eee') ?>;
                            ">
                                <?= htmlspecialchars($p['rarity'] ?? '') ?>
                            </span>
                        </td>
                        <td><?= htmlspecialchars($p['description'] ?? '') ?></td>
                    </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</body>
</html>
