<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin – Gestion Pokémon | Sinnoh Clicker</title>
    <style>
        /* ── Lien d'évitement (RGAA 1.1) ─────────────────────────────────── */
        .skip-link {
            position: absolute;
            top: -40px;
            left: 0;
            background: #007bff;
            color: #fff;
            padding: 8px 16px;
            z-index: 1000;
            border-radius: 0 0 4px 0;
            font-weight: 600;
            text-decoration: none;
            transition: top 0.2s;
        }
        .skip-link:focus { top: 0; }

        /* ── Focus visible (RGAA 10.7) ───────────────────────────────────── */
        :focus-visible {
            outline: 3px solid #005fcc;
            outline-offset: 3px;
        }

        /* ── Base ────────────────────────────────────────────────────────── */
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            padding: 20px;
            line-height: 1.6;
            color: #333;
            margin: 0;
        }
        h1, h2 { color: #2c3e50; }

        /* ── Breadcrumb / retour dashboard ──────────────────────────────── */
        .breadcrumb { margin-bottom: 16px; font-size: 14px; }
        .breadcrumb a { color: #007bff; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

        /* ── Cards ───────────────────────────────────────────────────────── */
        .card {
            background: #fff;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
            margin-bottom: 30px;
        }
        .card h2 { font-size: 18px; margin-bottom: 16px; }

        /* ── Formulaire ──────────────────────────────────────────────────── */
        .form-row { display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 15px; }
        .form-group { flex: 1; min-width: 200px; display: flex; flex-direction: column; }
        label { margin-bottom: 5px; font-weight: 500; }
        input, select, textarea {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            width: 100%;
        }
        input:invalid { border-color: #c0392b; }
        button[type="submit"] {
            padding: 10px 20px;
            background: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.2s;
        }
        button[type="submit"]:hover { background: #0056b3; }

        /* ── Barre de recherche RIA ──────────────────────────────────────── */
        .search-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }
        #search-input {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            flex: 1;
            min-width: 180px;
            max-width: 320px;
        }
        #result-count {
            font-size: 13px;
            color: #666;
        }

        /* ── Table ───────────────────────────────────────────────────────── */
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,.2);
        }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #e8f4fd; }
        tr[hidden] { display: none; }           /* masquage via RIA */

        /* ── Badges de rareté ────────────────────────────────────────────── */
        .badge-rarity {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-Legendary { background: #ffd700; color: #5a4000; }
        .badge-Epic      { background: #b39ddb; color: #311b92; }
        .badge-Rare      { background: #add8e6; color: #003050; }
        .badge-Uncommon  { background: #c8e6c9; color: #1b5e20; }
        .badge-Common    { background: #eee;    color: #333;    }

        /* ── Onglets de navigation admin ─────────────────────────────────── */
        .admin-tabs {
            display: flex; gap: 4px; margin: 12px 0 20px;
            border-bottom: 2px solid #dee2e6;
        }
        .admin-tabs a {
            padding: 8px 18px; border-radius: 6px 6px 0 0;
            text-decoration: none; font-weight: 500; font-size: 14px;
            color: #555; background: #f0f0f0;
            border: 1px solid #dee2e6; border-bottom: none;
            transition: background .15s;
        }
        .admin-tabs a:hover { background: #e2e6ea; color: #333; }
        .admin-tabs a.active {
            background: #fff; color: #007bff;
            border-color: #dee2e6; border-bottom-color: #fff;
            margin-bottom: -2px;
        }

        /* ── Responsive : tablette (≤ 768 px) ───────────────────────────── */
        @media (max-width: 768px) {
            body { padding: 12px; }
            .form-row { flex-direction: column; gap: 10px; }
            .form-group { min-width: unset; }
            th, td { padding: 8px; font-size: 13px; }
            /* Masque les colonnes secondaires sur tablette */
            .col-desc, .col-prod { display: none; }
        }

        /* ── Responsive : mobile (≤ 480 px) ─────────────────────────────── */
        @media (max-width: 480px) {
            h1 { font-size: 20px; }
            .card { padding: 14px; }
            /* Masque encore plus de colonnes sur mobile */
            .col-cost { display: none; }
        }
    </style>
</head>
<body>
    <!-- Lien d'évitement RGAA 1.1 -->
    <a href="#main-content" class="skip-link">Aller au contenu principal</a>

    <header role="banner">
        <nav aria-label="Fil d'Ariane" class="breadcrumb">
            <a href="/admin">&#8592; Dashboard</a>
            <span aria-hidden="true"> / </span>
            <span aria-current="page">Gestion Pokémon</span>
        </nav>
        <h1>Administration – Sinnoh Clicker</h1>
        <nav class="admin-tabs" aria-label="Sections admin">
            <a href="/admin/pokemon" class="active" aria-current="page">&#127918; Pok&eacute;mon</a>
            <a href="/admin/users">&#128101; Utilisateurs</a>
        </nav>
    </header>

    <main id="main-content">

        <!-- ── Section : ajout d'un Pokémon ─────────────────────────────── -->
        <section class="card" aria-labelledby="form-heading">
            <h2 id="form-heading">Ajouter un nouveau Pokémon</h2>

            <form action="/admin/pokemon" method="POST" aria-describedby="form-desc" novalidate>
                <p id="form-desc" style="font-size:13px;color:#666;margin-bottom:12px;">
                    Les champs marqués d'un <abbr title="obligatoire">*</abbr> sont obligatoires.
                </p>

                <div class="form-row">
                    <div class="form-group">
                        <label for="pokemon-name">
                            Nom du Pokémon <abbr title="obligatoire">*</abbr>
                        </label>
                        <input
                            type="text"
                            id="pokemon-name"
                            name="name"
                            required
                            placeholder="Ex : Pikachu"
                            aria-required="true"
                            autocomplete="off"
                        >
                    </div>
                    <div class="form-group">
                        <label for="pokemon-rarity">Rareté</label>
                        <select id="pokemon-rarity" name="rarity" aria-label="Sélectionner la rareté du Pokémon">
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
                        <label for="pokemon-cost">
                            Coût de base (Pokédollars) <abbr title="obligatoire">*</abbr>
                        </label>
                        <input
                            type="number"
                            id="pokemon-cost"
                            name="base_cost"
                            required
                            placeholder="100"
                            min="1"
                            aria-required="true"
                            aria-describedby="cost-hint"
                        >
                        <span id="cost-hint" style="font-size:12px;color:#666;margin-top:4px;">
                            Valeur entière positive (minimum 1 Pokédollar)
                        </span>
                    </div>
                    <div class="form-group">
                        <label for="pokemon-prod">
                            Production de base (clics/s) <abbr title="obligatoire">*</abbr>
                        </label>
                        <input
                            type="number"
                            id="pokemon-prod"
                            name="base_production"
                            required
                            placeholder="10"
                            min="1"
                            aria-required="true"
                        >
                    </div>
                </div>

                <div class="form-group" style="margin-bottom:15px;">
                    <label for="pokemon-desc">Description</label>
                    <textarea
                        id="pokemon-desc"
                        name="description"
                        rows="3"
                        placeholder="Description du Pokémon…"
                    ></textarea>
                </div>

                <button type="submit" aria-label="Ajouter ce Pokémon à la base de données">
                    Ajouter à la base de données
                </button>
            </form>
        </section>

        <!-- ── Section : inventaire ──────────────────────────────────────── -->
        <section class="card" aria-labelledby="table-heading">
            <h2 id="table-heading">Inventaire de référence (<code>ref_pokemon</code>)</h2>

            <!-- Barre de recherche côté client (RIA) -->
            <div class="search-bar" role="search" aria-label="Filtrer l'inventaire">
                <label for="search-input" style="font-weight:500;white-space:nowrap;">
                    Rechercher&nbsp;:
                </label>
                <input
                    type="search"
                    id="search-input"
                    placeholder="Nom ou rareté…"
                    aria-controls="pokemon-table"
                    aria-label="Filtrer les Pokémon par nom ou rareté"
                    autocomplete="off"
                >
                <span id="result-count" aria-live="polite" aria-atomic="true"></span>
            </div>

            <table id="pokemon-table" aria-label="Inventaire des Pokémon de référence">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nom</th>
                        <th scope="col" class="col-cost">Coût base</th>
                        <th scope="col" class="col-prod">Prod. base</th>
                        <th scope="col">Rareté</th>
                        <th scope="col" class="col-desc">Description</th>
                    </tr>
                </thead>
                <tbody id="pokemon-tbody">
                    <?php if (empty($pokemons)): ?>
                    <tr id="empty-row">
                        <td colspan="6" style="text-align:center;">Aucun Pokémon trouvé.</td>
                    </tr>
                    <?php else: ?>
                        <?php foreach ($pokemons as $p): ?>
                        <tr data-name="<?= htmlspecialchars(strtolower($p['name'] ?? '')) ?>"
                            data-rarity="<?= htmlspecialchars(strtolower($p['rarity'] ?? '')) ?>">
                            <td><?= htmlspecialchars($p['id'] ?? '') ?></td>
                            <td><?= htmlspecialchars($p['name'] ?? '') ?></td>
                            <td class="col-cost"><?= number_format($p['base_cost'] ?? 0) ?>&nbsp;$</td>
                            <td class="col-prod"><?= intval($p['base_production'] ?? 0) ?></td>
                            <td>
                                <?php
                                    $rarity = htmlspecialchars($p['rarity'] ?? '');
                                    $cls    = 'badge-' . $rarity;
                                ?>
                                <span class="badge-rarity <?= $cls ?>" aria-label="Rareté : <?= $rarity ?>">
                                    <?= $rarity ?>
                                </span>
                            </td>
                            <td class="col-desc"><?= htmlspecialchars($p['description'] ?? '') ?></td>
                        </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </section>

    </main>

    <script>
        /**
         * RIA – Filtrage dynamique de la table sans rechargement de page.
         * Écoute le champ de recherche et masque/affiche les lignes en temps réel.
         */
        (function () {
            const searchInput = document.getElementById('search-input');
            const tbody       = document.getElementById('pokemon-tbody');
            const counter     = document.getElementById('result-count');

            if (!searchInput || !tbody) return;

            const allRows = Array.from(tbody.querySelectorAll('tr[data-name]'));

            function filterTable() {
                const query = searchInput.value.trim().toLowerCase();
                let visible = 0;

                allRows.forEach(function (row) {
                    const name   = row.dataset.name   || '';
                    const rarity = row.dataset.rarity || '';
                    const match  = !query || name.includes(query) || rarity.includes(query);

                    row.hidden = !match;
                    if (match) visible++;
                });

                /* Mise à jour du compteur annoncée aux lecteurs d'écran (aria-live) */
                if (query) {
                    counter.textContent = visible + ' résultat' + (visible > 1 ? 's' : '');
                } else {
                    counter.textContent = '';
                }
            }

            searchInput.addEventListener('input', filterTable);
        })();
    </script>
</body>
</html>
