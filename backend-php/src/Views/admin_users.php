<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin – Gestion Utilisateurs | Sinnoh Clicker</title>
    <style>
        /* ── Lien d'évitement (RGAA 1.1) ─────────────────────────────────── */
        .skip-link {
            position: absolute; top: -40px; left: 0;
            background: #007bff; color: #fff; padding: 8px 16px;
            z-index: 1000; border-radius: 0 0 4px 0;
            font-weight: 600; text-decoration: none; transition: top .2s;
        }
        .skip-link:focus { top: 0; }

        /* ── Focus visible (RGAA 10.7) ───────────────────────────────────── */
        :focus-visible { outline: 3px solid #005fcc; outline-offset: 3px; }

        /* ── Accessibilité uniquement ────────────────────────────────────── */
        .sr-only {
            position: absolute; width: 1px; height: 1px;
            padding: 0; margin: -1px; overflow: hidden;
            clip: rect(0,0,0,0); white-space: nowrap; border: 0;
        }

        /* ── Base ────────────────────────────────────────────────────────── */
        * { box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            padding: 20px; line-height: 1.6; color: #333; margin: 0;
        }
        h1, h2 { color: #2c3e50; }

        /* ── Breadcrumb ──────────────────────────────────────────────────── */
        .breadcrumb { margin-bottom: 8px; font-size: 14px; }
        .breadcrumb a { color: #007bff; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

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

        /* ── Cards ───────────────────────────────────────────────────────── */
        .card {
            background: #fff; padding: 20px;
            border: 1px solid #ddd; border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,.1); margin-bottom: 24px;
        }

        /* ── En-tête de card : titre + barre d'outils ────────────────────── */
        .card-header {
            display: flex; align-items: center; flex-wrap: wrap;
            gap: 12px; margin-bottom: 14px;
        }
        .card-header h2 { margin: 0; font-size: 18px; flex: 1 1 auto; }
        .toolbar { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .toolbar input[type="search"] {
            padding: 7px 12px; border: 1px solid #ccc; border-radius: 4px;
            font-size: 14px; min-width: 180px; max-width: 280px;
        }
        .last-update-label { font-size: 12px; color: #888; white-space: nowrap; }

        /* ── Badge LIVE ──────────────────────────────────────────────────── */
        .live-badge {
            display: inline-flex; align-items: center; gap: 3px;
            font-size: 11px; font-weight: 700; color: #155724;
            background: #d4edda; border: 1px solid #c3e6cb;
            padding: 2px 8px; border-radius: 10px; vertical-align: middle;
            margin-left: 8px;
        }
        .live-badge.pulse { animation: livePulse .4s ease; }
        @keyframes livePulse {
            0%   { transform: scale(1); }
            50%  { transform: scale(1.12); }
            100% { transform: scale(1); }
        }

        /* ── Boutons ─────────────────────────────────────────────────────── */
        .btn {
            padding: 8px 16px; border: none; border-radius: 4px;
            cursor: pointer; font-size: 14px; font-weight: 500;
            transition: opacity .15s; line-height: 1.4;
        }
        .btn:hover { opacity: .88; }
        .btn:active { opacity: .72; }
        .btn:disabled { opacity: .5; cursor: not-allowed; }
        .btn-primary   { background: #007bff; color: #fff; }
        .btn-secondary { background: #6c757d; color: #fff; }
        .btn-danger    { background: #dc3545; color: #fff; }
        .btn-outline   { background: #fff; color: #333; border: 1px solid #ccc; }
        .btn-sm { padding: 4px 10px; font-size: 12px; border-radius: 3px; }

        /* ── Tables ──────────────────────────────────────────────────────── */
        .table-wrap { overflow-x: auto; }
        table {
            border-collapse: collapse; width: 100%;
            box-shadow: 0 1px 3px rgba(0,0,0,.12);
        }
        th, td { border: 1px solid #ddd; padding: 10px 12px; text-align: left; }
        th { background: #f8f9fa; font-weight: 600; font-size: 13px; }
        tr:nth-child(even) { background: #f9f9f9; }
        tr:hover { background: #e8f4fd; }
        td.num  { text-align: right; font-variant-numeric: tabular-nums; white-space: nowrap; }
        td.date { font-size: 12px; color: #555; white-space: nowrap; }
        td.actions { white-space: nowrap; }

        /* ── Badges de rareté ────────────────────────────────────────────── */
        .badge-rarity {
            display: inline-block; padding: 2px 8px;
            border-radius: 10px; font-size: 12px; font-weight: 600;
        }
        .badge-Legendary { background: #ffd700; color: #5a4000; }
        .badge-Epic      { background: #b39ddb; color: #311b92; }
        .badge-Rare      { background: #add8e6; color: #003050; }
        .badge-Uncommon  { background: #c8e6c9; color: #1b5e20; }
        .badge-Common    { background: #eee;    color: #333;    }

        /* ── Compteur de résultats ───────────────────────────────────────── */
        .result-count { font-size: 13px; color: #666; margin: 8px 0 0; }

        /* ── Ligne de retour ──────────────────────────────────────────────── */
        .back-row { display: flex; align-items: center; gap: 12px; flex: 1 1 auto; }
        .back-row h2 { margin: 0; }

        /* ── Bannière d'erreur ───────────────────────────────────────────── */
        .error-banner {
            background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24;
            border-radius: 4px; padding: 10px 14px; margin-bottom: 12px; font-size: 14px;
        }

        /* ── Fenêtre modale ──────────────────────────────────────────────── */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(0,0,0,.5); z-index: 100;
            display: flex; align-items: center; justify-content: center;
            padding: 16px;
        }
        .modal-box {
            background: #fff; border-radius: 8px; padding: 24px;
            max-width: 440px; width: 100%;
            box-shadow: 0 8px 32px rgba(0,0,0,.25);
        }
        .modal-box h3 { margin: 0 0 16px; font-size: 17px; color: #2c3e50; }
        .form-group { display: flex; flex-direction: column; margin-bottom: 14px; }
        .form-group label { font-weight: 500; margin-bottom: 4px; font-size: 14px; }
        .form-group input {
            padding: 8px 12px; border: 1px solid #ccc;
            border-radius: 4px; font-size: 14px;
        }
        .form-group input:focus { border-color: #007bff; outline: none; box-shadow: 0 0 0 2px rgba(0,123,255,.25); }
        .modal-actions { display: flex; gap: 8px; justify-content: flex-end; margin-top: 4px; }

        /* ── Toast de notification ───────────────────────────────────────── */
        #toast {
            position: fixed; bottom: 24px; right: 24px; z-index: 200;
            padding: 12px 20px; border-radius: 6px; font-size: 14px; font-weight: 500;
            box-shadow: 0 4px 12px rgba(0,0,0,.2); max-width: 340px;
        }
        #toast.toast-success { background: #28a745; color: #fff; }
        #toast.toast-error   { background: #dc3545; color: #fff; }

        /* ── Responsive : tablette (≤768px) ─────────────────────────────── */
        @media (max-width: 768px) {
            body { padding: 12px; }
            .card-header { flex-direction: column; align-items: flex-start; }
            th, td { padding: 7px 8px; font-size: 12px; }
            .col-email, .col-lifetime, .col-created { display: none; }
        }

        /* ── Responsive : mobile (≤480px) ───────────────────────────────── */
        @media (max-width: 480px) {
            h1 { font-size: 20px; }
            .card { padding: 14px; }
            .col-clicks, .col-lastsync { display: none; }
        }
    </style>
</head>
<body>
    <a href="#main-content" class="skip-link">Aller au contenu principal</a>

    <header role="banner">
        <nav aria-label="Fil d'Ariane" class="breadcrumb">
            <a href="/admin">&#8592; Dashboard</a>
            <span aria-hidden="true"> / </span>
            <span aria-current="page">Gestion Utilisateurs</span>
        </nav>
        <h1>Administration – Sinnoh Clicker</h1>
        <nav class="admin-tabs" aria-label="Sections admin">
            <a href="/admin/pokemon">&#127918; Pok&eacute;mon</a>
            <a href="/admin/users" class="active" aria-current="page">&#128101; Utilisateurs</a>
        </nav>
    </header>

    <main id="main-content">

        <!-- ── Section 1 : Statistiques des utilisateurs ─────────────────── -->
        <section class="card" aria-labelledby="users-heading">
            <div class="card-header">
                <h2 id="users-heading">
                    Statistiques des utilisateurs
                    <span class="live-badge" id="users-live-badge" aria-label="Mise à jour automatique active">&#9679; LIVE</span>
                </h2>
                <div class="toolbar">
                    <input
                        type="search"
                        id="search-users"
                        placeholder="Filtrer par nom / email&hellip;"
                        aria-label="Filtrer les utilisateurs"
                        autocomplete="off"
                    >
                    <span class="last-update-label" id="users-last-update" aria-live="polite">—</span>
                    <button class="btn btn-outline btn-sm" id="btn-refresh-users" aria-label="Actualiser la liste des utilisateurs">
                        &#8635; Actualiser
                    </button>
                </div>
            </div>

            <div id="users-error" class="error-banner" style="display:none" role="alert"></div>

            <div class="table-wrap">
                <table id="users-table" aria-label="Liste des utilisateurs et leurs statistiques">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Username</th>
                            <th scope="col" class="col-email">Email</th>
                            <th scope="col">Pok&eacute;dollars</th>
                            <th scope="col" class="col-lifetime">Gains totaux</th>
                            <th scope="col" class="col-clicks">Clics totaux</th>
                            <th scope="col" class="col-lastsync">Derni&egrave;re sync</th>
                            <th scope="col" class="col-created">Inscrit le</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="users-tbody">
                        <tr><td colspan="9" style="text-align:center;color:#888;">Chargement&hellip;</td></tr>
                    </tbody>
                </table>
            </div>
            <p class="result-count" id="users-count" aria-live="polite" aria-atomic="true"></p>
        </section>

        <!-- ── Section 2 : Inventaire d'un utilisateur ───────────────────── -->
        <section class="card" id="inventory-section" aria-labelledby="inv-heading" style="display:none">
            <div class="card-header">
                <div class="back-row">
                    <button class="btn btn-outline btn-sm" id="btn-close-inv">
                        &#8592; Retour
                    </button>
                    <h2 id="inv-heading">
                        Inventaire de <strong id="inv-username">—</strong>
                        <span class="live-badge" id="inv-live-badge" aria-label="Inventaire en temps réel">&#9679; LIVE</span>
                    </h2>
                </div>
                <div class="toolbar">
                    <input
                        type="search"
                        id="search-inv"
                        placeholder="Filtrer par nom&hellip;"
                        aria-label="Filtrer les Pokémon de l'inventaire"
                        autocomplete="off"
                    >
                    <span class="last-update-label" id="inv-last-update" aria-live="polite">—</span>
                </div>
            </div>

            <div id="inv-error" class="error-banner" style="display:none" role="alert"></div>

            <div class="table-wrap">
                <table id="inv-table" aria-label="Inventaire Pokémon de l'utilisateur sélectionné">
                    <thead>
                        <tr>
                            <th scope="col">Pok&eacute;mon</th>
                            <th scope="col">Rarete&#769;</th>
                            <th scope="col">Niveau</th>
                            <th scope="col">XP</th>
                            <th scope="col">Quantite&#769;</th>
                            <th scope="col" class="col-created">Capture&#769; le</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="inv-tbody">
                        <tr><td colspan="7" style="text-align:center;color:#888;">S&eacute;lectionnez un utilisateur pour voir son inventaire.</td></tr>
                    </tbody>
                </table>
            </div>
            <p class="result-count" id="inv-count" aria-live="polite" aria-atomic="true"></p>
        </section>

    </main>

    <!-- ── Modale : Modifier les statistiques ────────────────────────────── -->
    <div id="modal-stats" class="modal-overlay" hidden role="dialog" aria-modal="true" aria-labelledby="modal-stats-title">
        <div class="modal-box">
            <h3 id="modal-stats-title">Modifier les stats de <span id="modal-stats-username"></span></h3>
            <form id="form-stats" novalidate>
                <input type="hidden" id="f-user-id">
                <div class="form-group">
                    <label for="f-pokedollars">Pok&eacute;dollars <abbr title="obligatoire">*</abbr></label>
                    <input type="number" id="f-pokedollars" min="0" required>
                </div>
                <div class="form-group">
                    <label for="f-lifetime">Gains totaux (lifetime_earnings)</label>
                    <input type="number" id="f-lifetime" min="0">
                </div>
                <div class="form-group">
                    <label for="f-clicks">Total de clics</label>
                    <input type="number" id="f-clicks" min="0">
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-outline" id="btn-cancel-stats">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="btn-save-stats">Sauvegarder</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ── Modale : Modifier une entrée d'inventaire ─────────────────────── -->
    <div id="modal-inv" class="modal-overlay" hidden role="dialog" aria-modal="true" aria-labelledby="modal-inv-title">
        <div class="modal-box">
            <h3 id="modal-inv-title">Modifier &mdash; <span id="modal-inv-pokename"></span></h3>
            <form id="form-inv" novalidate>
                <input type="hidden" id="f-inv-pokemon-id">
                <div class="form-group">
                    <label for="f-inv-level">Niveau <abbr title="obligatoire">*</abbr></label>
                    <input type="number" id="f-inv-level" min="1" required>
                </div>
                <div class="form-group">
                    <label for="f-inv-xp">Exp&eacute;rience (XP)</label>
                    <input type="number" id="f-inv-xp" min="0">
                </div>
                <div class="form-group">
                    <label for="f-inv-qty">Quantit&eacute;</label>
                    <input type="number" id="f-inv-qty" min="0">
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn btn-outline" id="btn-cancel-inv">Annuler</button>
                    <button type="submit" class="btn btn-primary" id="btn-save-inv">Sauvegarder</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ── Toast de notification ─────────────────────────────────────────── -->
    <div id="toast" class="toast-success" hidden role="alert" aria-live="assertive"></div>

    <script>
    (function () {
        'use strict';

        /* ── Données initiales serveur ───────────────────────────────────── */
        let allUsers     = <?= json_encode($users, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP) ?>;
        let allInventory = [];
        let currentUserId   = null;
        let currentUserName = '';
        let usersTimer      = null;
        let invTimer        = null;

        /* ── Référence DOM ───────────────────────────────────────────────── */
        const $ = id => document.getElementById(id);

        /* ── Utilitaires ─────────────────────────────────────────────────── */
        function esc(str) {
            const d = document.createElement('div');
            d.textContent = String(str ?? '');
            return d.innerHTML;
        }

        function fmt(n) {
            return Number(n ?? 0).toLocaleString('fr-FR');
        }

        function fmtDate(d) {
            if (!d) return '—';
            try {
                return new Date(d).toLocaleString('fr-FR', {
                    day: '2-digit', month: '2-digit', year: 'numeric',
                    hour: '2-digit', minute: '2-digit'
                });
            } catch (_) { return String(d); }
        }

        function nowTime() {
            return new Date().toLocaleTimeString('fr-FR');
        }

        function pulseBadge(id) {
            const el = $(id);
            if (!el) return;
            el.classList.remove('pulse');
            void el.offsetWidth; // reflow pour relancer l'animation
            el.classList.add('pulse');
        }

        function showToast(msg, type = 'success') {
            const t = $('toast');
            t.textContent = msg;
            t.className = 'toast-' + type;
            Object.assign(t.style, {
                position: 'fixed', bottom: '24px', right: '24px', zIndex: '200',
                padding: '12px 20px', borderRadius: '6px', fontSize: '14px',
                fontWeight: '500', boxShadow: '0 4px 12px rgba(0,0,0,.2)', maxWidth: '340px'
            });
            t.style.background = type === 'success' ? '#28a745' : '#dc3545';
            t.style.color = '#fff';
            t.hidden = false;
            clearTimeout(t._timer);
            t._timer = setTimeout(() => { t.hidden = true; }, 3500);
        }

        /* ── Table Utilisateurs ──────────────────────────────────────────── */
        function renderUsers() {
            const q      = $('search-users').value.trim().toLowerCase();
            const tbody  = $('users-tbody');
            const count  = $('users-count');

            const filtered = allUsers.filter(u =>
                !q ||
                String(u.username ?? '').toLowerCase().includes(q) ||
                String(u.email    ?? '').toLowerCase().includes(q)
            );

            if (filtered.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;color:#888;">Aucun utilisateur trouvé.</td></tr>';
                count.textContent = '';
                return;
            }

            tbody.innerHTML = filtered.map(u => `
                <tr>
                    <td>${esc(u.id)}</td>
                    <td><strong>${esc(u.username)}</strong></td>
                    <td class="col-email" style="font-size:13px;">${esc(u.email)}</td>
                    <td class="num">${fmt(u.pokedollars)}&nbsp;$</td>
                    <td class="num col-lifetime">${fmt(u.lifetime_earnings)}&nbsp;$</td>
                    <td class="num col-clicks">${fmt(u.total_clicks)}</td>
                    <td class="date col-lastsync">${fmtDate(u.last_sync)}</td>
                    <td class="date col-created">${fmtDate(u.created_at)}</td>
                    <td class="actions">
                        <button class="btn btn-primary btn-sm"
                            data-action="edit-stats"
                            data-id="${esc(u.id)}"
                            data-username="${esc(u.username)}"
                            data-pokedollars="${u.pokedollars ?? 0}"
                            data-lifetime="${u.lifetime_earnings ?? 0}"
                            data-clicks="${u.total_clicks ?? 0}"
                            aria-label="Modifier les stats de ${esc(u.username)}">
                            &#9998; Stats
                        </button>
                        <button class="btn btn-secondary btn-sm"
                            data-action="view-inventory"
                            data-id="${esc(u.id)}"
                            data-username="${esc(u.username)}"
                            aria-label="Voir l'inventaire de ${esc(u.username)}">
                            &#128230; Inventaire
                        </button>
                    </td>
                </tr>
            `).join('');

            const n = filtered.length;
            count.textContent = n + ' utilisateur' + (n > 1 ? 's' : '');
        }

        async function refreshUsers() {
            try {
                const res = await fetch('/admin/api/users', { credentials: 'include' });
                if (!res.ok) { showUsersError('Erreur HTTP ' + res.status); return; }
                const data = await res.json();
                if (data.error) { showUsersError(data.error); return; }
                allUsers = data.users ?? [];
                hideUsersError();
                renderUsers();
                $('users-last-update').textContent = 'Actualisé à ' + nowTime();
                pulseBadge('users-live-badge');
            } catch (err) {
                showUsersError('Erreur réseau : ' + err.message);
            }
        }

        function showUsersError(msg) {
            const el = $('users-error');
            el.textContent = '⚠ ' + msg;
            el.style.display = 'block';
        }
        function hideUsersError() { $('users-error').style.display = 'none'; }

        /* ── Table Inventaire ────────────────────────────────────────────── */
        function renderInventory() {
            const q      = $('search-inv').value.trim().toLowerCase();
            const tbody  = $('inv-tbody');
            const count  = $('inv-count');

            const filtered = allInventory.filter(item => {
                if (!q) return true;
                const name = String(item.pokemon?.name ?? item.pokemon_id ?? '').toLowerCase();
                return name.includes(q);
            });

            if (filtered.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;color:#888;">Aucun Pokémon dans l\'inventaire.</td></tr>';
                count.textContent = '';
                return;
            }

            tbody.innerHTML = filtered.map(item => {
                const poke   = item.pokemon ?? {};
                const name   = poke.name   ?? ('#' + item.pokemon_id);
                const rarity = poke.rarity ?? '';
                const badgeCls = rarity ? ' badge-' + esc(rarity) : '';
                return `
                    <tr>
                        <td>
                            <strong>${esc(name)}</strong>
                            <br><small style="color:#888;">#${esc(item.pokemon_id)}</small>
                        </td>
                        <td>
                            ${rarity
                                ? `<span class="badge-rarity${badgeCls}" aria-label="Rareté : ${esc(rarity)}">${esc(rarity)}</span>`
                                : '—'
                            }
                        </td>
                        <td class="num">${item.level ?? 1}</td>
                        <td class="num">${fmt(item.experience)}</td>
                        <td class="num">${item.quantity ?? 1}</td>
                        <td class="date col-created">${fmtDate(item.acquired_at)}</td>
                        <td class="actions">
                            <button class="btn btn-primary btn-sm"
                                data-action="edit-inv"
                                data-pokemon-id="${esc(item.pokemon_id)}"
                                data-pokemon-name="${esc(name)}"
                                data-level="${item.level ?? 1}"
                                data-xp="${item.experience ?? 0}"
                                data-qty="${item.quantity ?? 1}"
                                aria-label="Modifier ${esc(name)}">
                                &#9998;
                            </button>
                            <button class="btn btn-danger btn-sm"
                                data-action="delete-inv"
                                data-pokemon-id="${esc(item.pokemon_id)}"
                                data-pokemon-name="${esc(name)}"
                                aria-label="Supprimer ${esc(name)} de l'inventaire">
                                &#128465;
                            </button>
                        </td>
                    </tr>
                `;
            }).join('');

            const n = filtered.length;
            count.textContent = n + ' Pokémon';
        }

        async function loadInventory(userId, username) {
            currentUserId   = userId;
            currentUserName = username;
            $('inv-username').textContent = username;
            $('search-inv').value = '';
            allInventory = [];
            $('inv-tbody').innerHTML = '<tr><td colspan="7" style="text-align:center;color:#888;">Chargement…</td></tr>';
            $('inventory-section').style.display = '';
            $('inventory-section').scrollIntoView({ behavior: 'smooth', block: 'start' });

            await refreshInventory();

            if (invTimer) clearInterval(invTimer);
            invTimer = setInterval(refreshInventory, 10000);
        }

        async function refreshInventory() {
            if (!currentUserId) return;
            try {
                const res = await fetch(`/admin/api/users/${currentUserId}/inventory`, { credentials: 'include' });
                if (!res.ok) { showInvError('Erreur HTTP ' + res.status); return; }
                const data = await res.json();
                if (data.error) { showInvError(data.error); return; }
                allInventory = data.inventory ?? [];
                hideInvError();
                renderInventory();
                $('inv-last-update').textContent = 'Actualisé à ' + nowTime();
                pulseBadge('inv-live-badge');
            } catch (err) {
                showInvError('Erreur réseau : ' + err.message);
            }
        }

        function closeInventory() {
            $('inventory-section').style.display = 'none';
            currentUserId = null;
            if (invTimer) clearInterval(invTimer);
            invTimer = null;
            allInventory = [];
        }

        function showInvError(msg) {
            const el = $('inv-error');
            el.textContent = '⚠ ' + msg;
            el.style.display = 'block';
        }
        function hideInvError() { $('inv-error').style.display = 'none'; }

        /* ── Modale Stats ────────────────────────────────────────────────── */
        function openStatsModal(id, username, pokedollars, lifetime, clicks) {
            $('f-user-id').value               = id;
            $('modal-stats-username').textContent = username;
            $('f-pokedollars').value            = pokedollars;
            $('f-lifetime').value               = lifetime;
            $('f-clicks').value                 = clicks;
            $('modal-stats').hidden             = false;
            $('f-pokedollars').focus();
        }

        function closeStatsModal() { $('modal-stats').hidden = true; }

        $('form-stats').addEventListener('submit', async function (e) {
            e.preventDefault();
            const userId = $('f-user-id').value;
            const btn    = $('btn-save-stats');
            btn.disabled    = true;
            btn.textContent = 'Sauvegarde…';

            const payload = {
                pokedollars:       parseInt($('f-pokedollars').value) || 0,
                lifetime_earnings: parseInt($('f-lifetime').value)    || 0,
                total_clicks:      parseInt($('f-clicks').value)      || 0,
            };

            try {
                const res  = await fetch(`/admin/api/users/${userId}/stats`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify(payload),
                });
                const data = await res.json();
                if (!res.ok || data.error) {
                    showToast(data.error ?? 'Erreur lors de la mise à jour', 'error');
                } else {
                    closeStatsModal();
                    await refreshUsers();
                    showToast('Statistiques mises à jour ✓');
                }
            } catch (err) {
                showToast('Erreur réseau : ' + err.message, 'error');
            } finally {
                btn.disabled    = false;
                btn.textContent = 'Sauvegarder';
            }
        });

        /* ── Modale Inventaire ───────────────────────────────────────────── */
        function openInvModal(pokemonId, pokemonName, level, xp, qty) {
            $('f-inv-pokemon-id').value    = pokemonId;
            $('modal-inv-pokename').textContent = pokemonName;
            $('f-inv-level').value         = level;
            $('f-inv-xp').value            = xp;
            $('f-inv-qty').value           = qty;
            $('modal-inv').hidden          = false;
            $('f-inv-level').focus();
        }

        function closeInvModal() { $('modal-inv').hidden = true; }

        $('form-inv').addEventListener('submit', async function (e) {
            e.preventDefault();
            const btn = $('btn-save-inv');
            btn.disabled    = true;
            btn.textContent = 'Sauvegarde…';

            const payload = {
                pokemon_id: parseInt($('f-inv-pokemon-id').value),
                level:      parseInt($('f-inv-level').value)  || 1,
                experience: parseInt($('f-inv-xp').value)     || 0,
                quantity:   parseInt($('f-inv-qty').value)    || 0,
                action:     'update',
            };

            try {
                const res  = await fetch(`/admin/api/users/${currentUserId}/inventory`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify(payload),
                });
                const data = await res.json();
                if (!res.ok || data.error) {
                    showToast(data.error ?? 'Erreur lors de la mise à jour', 'error');
                } else {
                    closeInvModal();
                    await refreshInventory();
                    showToast('Inventaire mis à jour ✓');
                }
            } catch (err) {
                showToast('Erreur réseau : ' + err.message, 'error');
            } finally {
                btn.disabled    = false;
                btn.textContent = 'Sauvegarder';
            }
        });

        async function deleteInventoryEntry(pokemonId, pokemonName) {
            if (!confirm(`Supprimer "${pokemonName}" de l'inventaire de ${currentUserName} ?`)) return;
            try {
                const res  = await fetch(`/admin/api/users/${currentUserId}/inventory`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'include',
                    body: JSON.stringify({ pokemon_id: pokemonId, action: 'delete' }),
                });
                const data = await res.json();
                if (!res.ok || data.error) {
                    showToast(data.error ?? 'Erreur lors de la suppression', 'error');
                } else {
                    await refreshInventory();
                    showToast(pokemonName + ' supprimé de l\'inventaire ✓');
                }
            } catch (err) {
                showToast('Erreur réseau : ' + err.message, 'error');
            }
        }

        /* ── Délégation d'événements ─────────────────────────────────────── */
        $('users-tbody').addEventListener('click', function (e) {
            const btn = e.target.closest('[data-action]');
            if (!btn) return;
            if (btn.dataset.action === 'edit-stats') {
                openStatsModal(
                    btn.dataset.id,
                    btn.dataset.username,
                    parseInt(btn.dataset.pokedollars) || 0,
                    parseInt(btn.dataset.lifetime)    || 0,
                    parseInt(btn.dataset.clicks)      || 0
                );
            } else if (btn.dataset.action === 'view-inventory') {
                loadInventory(btn.dataset.id, btn.dataset.username);
            }
        });

        $('inv-tbody').addEventListener('click', function (e) {
            const btn = e.target.closest('[data-action]');
            if (!btn) return;
            if (btn.dataset.action === 'edit-inv') {
                openInvModal(
                    btn.dataset.pokemonId,
                    btn.dataset.pokemonName,
                    parseInt(btn.dataset.level) || 1,
                    parseInt(btn.dataset.xp)    || 0,
                    parseInt(btn.dataset.qty)   || 1
                );
            } else if (btn.dataset.action === 'delete-inv') {
                deleteInventoryEntry(
                    parseInt(btn.dataset.pokemonId),
                    btn.dataset.pokemonName
                );
            }
        });

        /* ── Autres handlers ─────────────────────────────────────────────── */
        $('btn-refresh-users').addEventListener('click', refreshUsers);
        $('btn-close-inv').addEventListener('click', closeInventory);
        $('btn-cancel-stats').addEventListener('click', closeStatsModal);
        $('btn-cancel-inv').addEventListener('click', closeInvModal);
        $('search-users').addEventListener('input', renderUsers);
        $('search-inv').addEventListener('input', renderInventory);

        // Fermer les modales en cliquant sur l'arrière-plan
        $('modal-stats').addEventListener('click', function (e) {
            if (e.target === this) closeStatsModal();
        });
        $('modal-inv').addEventListener('click', function (e) {
            if (e.target === this) closeInvModal();
        });

        // Fermer les modales avec la touche Échap
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                if (!$('modal-stats').hidden) closeStatsModal();
                if (!$('modal-inv').hidden)   closeInvModal();
            }
        });

        /* ── Initialisation ──────────────────────────────────────────────── */
        renderUsers();
        $('users-last-update').textContent = 'Actualisé à ' + nowTime();

        // Actualisation automatique toutes les 10 secondes
        usersTimer = setInterval(refreshUsers, 10000);

        // Nettoyage des timers à la fermeture de la page
        window.addEventListener('beforeunload', function () {
            clearInterval(usersTimer);
            clearInterval(invTimer);
        });

    })();
    </script>
</body>
</html>
