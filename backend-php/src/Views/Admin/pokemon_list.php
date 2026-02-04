<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Pokemon Management</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .form-container { background: #f9f9f9; padding: 20px; border-radius: 5px; border: 1px solid #ddd; }
        .form-group { margin-bottom: 10px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; box-sizing: border-box; }
        button { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; }
        button:hover { background-color: #45a049; }
        .error { color: red; margin-bottom: 10px; }
    </style>
</head>
<body>

<h1>Game Master: Pokemon Management</h1>

<div class="form-container">
    <h2>Add New Pokemon</h2>
    <?php if (isset($error)): ?>
        <div class="error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <form action="/admin/pokemon/add" method="POST">
        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="base_cost">Base Cost (Pokedollars):</label>
            <input type="number" id="base_cost" name="base_cost" required>
        </div>
        <div class="form-group">
            <label for="rarity">Rarity:</label>
            <select id="rarity" name="rarity">
                <option value="Common">Common</option>
                <option value="Rare">Rare</option>
                <option value="Legendary">Legendary</option>
            </select>
        </div>
        <div class="form-group">
            <label for="base_production">Base Production:</label>
            <input type="number" id="base_production" name="base_production" step="0.1" value="1.0">
        </div>
        <div class="form-group">
            <label for="region_origin">Region:</label>
            <input type="text" id="region_origin" name="region_origin" value="Sinnoh">
        </div>
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description"></textarea>
        </div>
        <button type="submit">Add Pokemon</button>
    </form>
</div>

<h2>Existing Pokemon</h2>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Rarity</th>
            <th>Base Cost</th>
            <th>Base Production</th>
            <th>Region</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($pokemons as $poke): ?>
        <tr>
            <td><?= htmlspecialchars($poke['id']) ?></td>
            <td><?= htmlspecialchars($poke['name']) ?></td>
            <td><?= htmlspecialchars($poke['rarity']) ?></td>
            <td><?= number_format($poke['base_cost']) ?> P$</td>
            <td><?= htmlspecialchars($poke['base_production']) ?></td>
            <td><?= htmlspecialchars($poke['region_origin']) ?></td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>

</body>
</html>
