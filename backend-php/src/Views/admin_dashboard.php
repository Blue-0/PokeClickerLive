<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PokeClicker - Dashboard Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background: #1a1a2e;
            color: #e0e0e0;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #16213e 0%, #0f3460 100%);
            padding: 24px 40px;
            border-bottom: 3px solid #e94560;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .header h1 {
            font-size: 24px;
            color: #fff;
        }
        .header .badge {
            background: #e94560;
            color: #fff;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 20px; }
        .status-bar {
            display: flex;
            align-items: center;
            gap: 12px;
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
        }
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
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }
        .stat-card .label { font-size: 13px; color: #8892b0; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .stat-card .value { font-size: 36px; font-weight: 700; color: #e94560; }
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
        .nav-card .icon { font-size: 32px; width: 48px; text-align: center; }
        .nav-card .info h3 { font-size: 16px; color: #fff; margin-bottom: 4px; }
        .nav-card .info p { font-size: 13px; color: #8892b0; }
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
    </style>
</head>
<body>
    <div class="header">
        <h1>Sinnoh Clicker</h1>
        <span class="badge">Admin Dashboard</span>
    </div>

    <div class="container">
        <div class="status-bar">
            <span class="status-dot"></span>
            <span>Supabase: <strong><?= ($stats['supabase_status'] ?? false) ? 'Connecte' : 'Deconnecte' ?></strong></span>
            <span style="color:#8892b0;margin-left:auto;">
                <?= htmlspecialchars(SUPABASE_URL) ?>
            </span>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Joueurs</div>
                <div class="value"><?= $stats['users'] ?? 0 ?></div>
            </div>
            <div class="stat-card">
                <div class="label">Pokemon (ref)</div>
                <div class="value"><?= $stats['pokemon'] ?? 0 ?></div>
            </div>
            <div class="stat-card">
                <div class="label">Pokemon captures</div>
                <div class="value"><?= $stats['user_pokemon'] ?? 0 ?></div>
            </div>
        </div>

        <div class="nav-section">
            <h2>Administration</h2>
            <div class="nav-grid">
                <a href="/admin/pokemon" class="nav-card">
                    <div class="icon">&#9881;</div>
                    <div class="info">
                        <h3>Gestion Pokemon</h3>
                        <p>Ajouter, modifier les Pokemon de reference</p>
                    </div>
                </a>
                <a href="/api/test" class="nav-card">
                    <div class="icon">&#9889;</div>
                    <div class="info">
                        <h3>Health Check API</h3>
                        <p>Tester la connexion Supabase</p>
                    </div>
                </a>
                <a href="/api/pokemon" class="nav-card">
                    <div class="icon">&#127918;</div>
                    <div class="info">
                        <h3>API Pokemon</h3>
                        <p>Liste des Pokemon Sinnoh (JSON)</p>
                    </div>
                </a>
            </div>
        </div>

        <div class="api-section">
            <h2>Endpoints API</h2>
            <table class="api-table">
                <thead>
                    <tr>
                        <th>Methode</th>
                        <th>Endpoint</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="method method-get">GET</span></td>
                        <td><code>/api/test</code></td>
                        <td>Health check + test Supabase</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post">POST</span></td>
                        <td><code>/api/auth/register</code></td>
                        <td>Inscription utilisateur</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post">POST</span></td>
                        <td><code>/api/auth/login</code></td>
                        <td>Connexion + JWT</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get">GET</span></td>
                        <td><code>/api/auth/me</code></td>
                        <td>Profil utilisateur (JWT requis)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get">GET</span></td>
                        <td><code>/api/pokemon</code></td>
                        <td>Liste Pokemon Sinnoh (pagine)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-get">GET</span></td>
                        <td><code>/api/pokemon/{id}</code></td>
                        <td>Detail d'un Pokemon</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post">POST</span></td>
                        <td><code>/api/pokemon/catch</code></td>
                        <td>Capturer un Pokemon (JWT requis)</td>
                    </tr>
                    <tr>
                        <td><span class="method method-post">POST</span></td>
                        <td><code>/api/user/sync</code></td>
                        <td>Synchronisation cloud save</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
