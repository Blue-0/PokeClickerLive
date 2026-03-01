<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PokeClicker - Dashboard Admin</title>
    <style>
        /* ── Lien d'évitement (RGAA 1.1) ─────────────────────────────────── */
        .skip-link {
            position: absolute;
            top: -40px;
            left: 0;
            background: #e94560;
            color: #fff;
            padding: 8px 16px;
            z-index: 1000;
            border-radius: 0 0 4px 0;
            font-weight: 600;
            transition: top 0.2s;
        }
        .skip-link:focus { top: 0; }

        /* ── Reset / Base ─────────────────────────────────────────────────── */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: #1a1a2e;
            color: #e0e0e0;
            min-height: 100vh;
        }

        /* ── Focus visible (RGAA 10.7) ───────────────────────────────────── */
        :focus-visible {
            outline: 3px solid #64ffda;
            outline-offset: 3px;
        }

        /* ── Header ──────────────────────────────────────────────────────── */
        .header {
            background: linear-gradient(135deg, #16213e 0%, #0f3460 100%);
            padding: 24px 40px;
            border-bottom: 3px solid #e94560;
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .header h1 { font-size: 24px; color: #fff; }
        .header .badge {
            background: #e94560;
            color: #fff;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        /* ── Container ───────────────────────────────────────────────────── */
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 20px; }

        /* ── Status Bar ──────────────────────────────────────────────────── */
        .status-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 32px;
            padding: 16px 20px;
            background: #16213e;
            border-radius: 8px;
            border-left: 4px solid <?= ($stats['supabase_status'] ?? false) ? '#00c853' : '#e94560' ?>;
        }
        .status-dot {
            width: 12px; height: 12px;
            border-radius: 50%;
            background: <?= ($stats['supabase_status'] ?? false) ? '#00c853' : '#e94560' ?>;
            box-shadow: 0 0 8px <?= ($stats['supabase_status'] ?? false) ? '#00c853' : '#e94560' ?>;
            flex-shrink: 0;
        }
        .status-url { color: #8892b0; margin-left: auto; font-size: 13px; word-break: break-all; }

        /* ── Bouton Rafraîchir (AJAX) ────────────────────────────────────── */
        #refresh-btn {
            margin-left: 12px;
            padding: 6px 14px;
            background: #0f3460;
            color: #64ffda;
            border: 1px solid #64ffda;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }
        #refresh-btn:hover:not(:disabled) { background: #64ffda; color: #0f3460; }
        #refresh-btn:disabled { opacity: 0.6; cursor: not-allowed; }

        /* ── Stats Grid ──────────────────────────────────────────────────── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: #16213e;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #0f3460;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.3); }
        .stat-card .label { font-size: 13px; color: #8892b0; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .stat-card .value { font-size: 36px; font-weight: 700; color: #e94560; }

        /* ── Navigation ──────────────────────────────────────────────────── */
        .nav-section h2 { font-size: 18px; color: #ccd6f6; margin-bottom: 16px; }
        .nav-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 16px;
        }
        .nav-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 20px;
            background: #16213e;
            border-radius: 10px;
            border: 1px solid #0f3460;
            text-decoration: none;
            color: #e0e0e0;
            transition: border-color 0.2s, background 0.2s;
        }
        .nav-card:hover { border-color: #e94560; background: #1a2744; }
        .nav-card .icon { font-size: 32px; width: 48px; text-align: center; flex-shrink: 0; }
        .nav-card .info h3 { font-size: 16px; color: #fff; margin-bottom: 4px; }
        .nav-card .info p { font-size: 13px; color: #8892b0; }

        /* ── API Table ───────────────────────────────────────────────────── */
        .api-section { margin-top: 40px; }
        .api-section h2 { font-size: 18px; color: #ccd6f6; margin-bottom: 16px; }
        .api-table { width: 100%; border-collapse: collapse; background: #16213e; border-radius: 8px; overflow: hidden; }
        .api-table th { background: #0f3460; padding: 12px 16px; text-align: left; font-size: 13px; color: #8892b0; text-transform: uppercase; letter-spacing: 1px; }
        .api-table td { padding: 12px 16px; border-top: 1px solid #0f3460; font-size: 14px; }
        .api-table tr:hover td { background: #1a2744; }
        .method { padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: 700; font-family: monospace; }
        .method-get { background: #1b5e20; color: #69f0ae; }
        .method-post { background: #e65100; color: #ffab40; }
        code { background: #0f3460; padding: 2px 8px; border-radius: 4px; font-size: 13px; color: #64ffda; }

        /* ── Responsive : tablette (≤ 768 px) ───────────────────────────── */
        @media (max-width: 768px) {
            .header { padding: 16px 20px; }
            .container { padding: 20px 12px; }
            .stats-grid { grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; }
            .stat-card { padding: 16px; }
            .stat-card .value { font-size: 28px; }
            .nav-grid { grid-template-columns: 1fr; }
            .status-url { display: none; }
            .api-table th, .api-table td { padding: 8px 10px; font-size: 13px; }
        }

        /* ── Responsive : mobile (≤ 480 px) ─────────────────────────────── */
        @media (max-width: 480px) {
            .header h1 { font-size: 18px; }
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .stat-card .value { font-size: 22px; }
            /* Masque les colonnes secondaires du tableau API */
            .api-table .col-desc { display: none; }
        }
    </style>
</head>
<body>
    <!-- Lien d'évitement RGAA 1.1 -->
    <a href="#main-content" class="skip-link">Aller au contenu principal</a>

    <header class="header" role="banner">
        <h1>Sinnoh Clicker</h1>
        <span class="badge" aria-label="Section : tableau de bord d'administration">Admin Dashboard</span>
    </header>

    <main id="main-content" class="container">

        <!-- Barre de statut avec région ARIA live (RGAA 7.3) -->
        <section aria-labelledby="status-heading">
            <h2 id="status-heading" class="sr-only" style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);">Statut de la connexion</h2>
            <div class="status-bar" role="status" id="status-bar">
                <span class="status-dot" id="status-dot" aria-hidden="true"></span>
                <span id="status-text">
                    Supabase&nbsp;:&nbsp;<strong><?= ($stats['supabase_status'] ?? false) ? 'Connecté' : 'Déconnecté' ?></strong>
                </span>
                <button id="refresh-btn" type="button" aria-label="Rafraîchir le statut de connexion via l'API">
                    Rafraîchir
                </button>
                <span class="status-url" aria-label="URL Supabase">
                    <?= htmlspecialchars(SUPABASE_URL) ?>
                </span>
            </div>
            <!-- Région annoncée aux lecteurs d'écran lors des mises à jour AJAX -->
            <div id="status-live" aria-live="polite" aria-atomic="true"
                 style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);"></div>
        </section>

        <!-- Statistiques -->
        <section aria-labelledby="stats-heading">
            <h2 id="stats-heading" class="sr-only" style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);">Statistiques du jeu</h2>
            <div class="stats-grid">
                <div class="stat-card" role="region" aria-label="Nombre de joueurs">
                    <div class="label">Joueurs</div>
                    <div class="value" id="stat-users"><?= intval($stats['users'] ?? 0) ?></div>
                </div>
                <div class="stat-card" role="region" aria-label="Nombre de Pokémon de référence">
                    <div class="label">Pokémon (réf.)</div>
                    <div class="value" id="stat-pokemon"><?= intval($stats['pokemon'] ?? 0) ?></div>
                </div>
                <div class="stat-card" role="region" aria-label="Pokémon capturés">
                    <div class="label">Pokémon capturés</div>
                    <div class="value" id="stat-captures"><?= intval($stats['user_pokemon'] ?? 0) ?></div>
                </div>
            </div>
        </section>

        <!-- Navigation admin -->
        <nav aria-label="Navigation de l'administration">
            <h2 class="nav-section" style="font-size:18px;color:#ccd6f6;margin-bottom:16px;">Administration</h2>
            <div class="nav-grid">
                <a href="/admin/pokemon" class="nav-card" aria-label="Gestion des Pokémon – Ajouter, modifier les Pokémon de référence">
                    <span class="icon" aria-hidden="true">&#9881;</span>
                    <div class="info">
                        <h3>Gestion Pokémon</h3>
                        <p>Ajouter, modifier les Pokémon de référence</p>
                    </div>
                </a>
                <a href="/api/test" class="nav-card" aria-label="Health Check API – Tester la connexion Supabase">
                    <span class="icon" aria-hidden="true">&#9889;</span>
                    <div class="info">
                        <h3>Health Check API</h3>
                        <p>Tester la connexion Supabase</p>
                    </div>
                </a>
                <a href="/api/pokemon" class="nav-card" aria-label="API Pokémon – Liste des Pokémon Sinnoh en JSON">
                    <span class="icon" aria-hidden="true">&#127918;</span>
                    <div class="info">
                        <h3>API Pokémon</h3>
                        <p>Liste des Pokémon Sinnoh (JSON)</p>
                    </div>
                </a>
            </div>
        </nav>

        <!-- Table des endpoints API -->
        <section class="api-section" aria-labelledby="api-heading">
            <h2 id="api-heading">Endpoints API</h2>
            <table class="api-table" aria-label="Liste des endpoints de l'API PokeClicker">
                <thead>
                    <tr>
                        <th scope="col">Méthode</th>
                        <th scope="col">Endpoint</th>
                        <th scope="col" class="col-desc">Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="method method-get" aria-label="Méthode GET">GET</span></td>
                        <td><code>/api/test</code></td>
                        <td class="col-desc">Health check + test Supabase</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post" aria-label="Méthode POST">POST</span></td>
                        <td><code>/api/auth/register</code></td>
                        <td class="col-desc">Inscription utilisateur</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post" aria-label="Méthode POST">POST</span></td>
                        <td><code>/api/auth/login</code></td>
                        <td class="col-desc">Connexion + JWT</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get" aria-label="Méthode GET">GET</span></td>
                        <td><code>/api/auth/me</code></td>
                        <td class="col-desc">Profil utilisateur (JWT requis)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get" aria-label="Méthode GET">GET</span></td>
                        <td><code>/api/pokemon</code></td>
                        <td class="col-desc">Liste Pokémon Sinnoh (paginée)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get" aria-label="Méthode GET">GET</span></td>
                        <td><code>/api/pokemon/{id}</code></td>
                        <td class="col-desc">Détail d'un Pokémon</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post" aria-label="Méthode POST">POST</span></td>
                        <td><code>/api/pokemon/catch</code></td>
                        <td class="col-desc">Capturer un Pokémon (JWT requis)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post" aria-label="Méthode POST">POST</span></td>
                        <td><code>/api/user/sync</code></td>
                        <td class="col-desc">Synchronisation cloud save</td>
                    </tr>
                </tbody>
            </table>
        </section>

    </main>

    <script>
        /**
         * AJAX – Rafraîchissement dynamique du statut Supabase (RIA)
         * Appelle GET /api/test et met à jour la barre de statut sans rechargement.
         */
        (function () {
            const btn        = document.getElementById('refresh-btn');
            const dot        = document.getElementById('status-dot');
            const statusText = document.getElementById('status-text');
            const liveRegion = document.getElementById('status-live');
            const statusBar  = document.getElementById('status-bar');

            function setStatus(connected, message) {
                const color = connected ? '#00c853' : '#e94560';
                dot.style.background  = color;
                dot.style.boxShadow   = `0 0 8px ${color}`;
                statusBar.style.borderLeftColor = color;

                const label = connected ? 'Connecté' : 'Déconnecté';
                statusText.innerHTML  = `Supabase&nbsp;:&nbsp;<strong>${label}</strong>`;

                /* Annonce pour les lecteurs d'écran */
                liveRegion.textContent = message || `Supabase ${label}`;
            }

            btn.addEventListener('click', async function () {
                btn.disabled = true;
                btn.textContent = 'Vérification…';
                btn.setAttribute('aria-busy', 'true');
                liveRegion.textContent = 'Vérification du statut en cours…';

                try {
                    /* ── Requête AJAX vers l'endpoint de health-check ── */
                    const response = await fetch('/api/test', {
                        method: 'GET',
                        headers: { 'Accept': 'application/json' }
                    });
                    const data = await response.json();

                    const connected = (data.status === 'success');
                    setStatus(connected, connected
                        ? 'Supabase connecté avec succès'
                        : 'Supabase déconnecté : ' + (data.error ?? 'erreur inconnue')
                    );
                } catch (err) {
                    setStatus(false, 'Erreur réseau lors de la vérification');
                } finally {
                    btn.disabled = false;
                    btn.textContent = 'Rafraîchir';
                    btn.removeAttribute('aria-busy');
                }
            });
        })();
    </script>
</body>
</html>
