<?php
// backend-php/public/index.php

// 1. Autoloader simple (PSR-4 compliant)
spl_autoload_register(function ($class) {
    $prefix = 'App\\';
    $base_dir = __DIR__ . '/../src/';

    // Vérifie si la classe utilise le préfixe
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0)
        return;

    // Récupère le chemin relatif
    $relative_class = substr($class, $len);

    // Remplace les namespaces par des /
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';

    // Si le fichier existe, on le charge
    if (file_exists($file)) {
        require $file;
    }
});

use App\Utils\Router;
use App\Utils\Env;

// 2. Configuration Globale
// Load .env if present (in containers, env vars are injected by the orchestrator)
Env::load(__DIR__ . '/../.env');

define('SUPABASE_URL', getenv('SUPABASE_URL'));
define('SUPABASE_KEY', getenv('SUPABASE_KEY'));
define('SUPABASE_SERVICE_KEY', getenv('SUPABASE_SERVICE_KEY'));
// JWT_SECRET must be set in the environment (.env) – never rely on the fallback in production
define('JWT_SECRET', getenv('JWT_SECRET') ?: 'pokeclicker_secret_change_in_production');

// 3. Lancement du Routeur
try {
    $router = new Router();

    // Dashboard (root)
    $router->get('/', \App\Controllers\Admin\DashboardController::class, 'index');
    $router->get('/admin', \App\Controllers\Admin\DashboardController::class, 'index');

    // Routes definition
    $router->get('/api/test', \App\Controllers\Api\TestController::class, 'ping');

    // Auth API routes
    $router->post('/api/auth/register', \App\Controllers\Api\AuthController::class, 'register');
    $router->post('/api/auth/login', \App\Controllers\Api\AuthController::class, 'login');
    $router->get('/api/auth/me', \App\Controllers\Api\AuthController::class, 'me');
    $router->post('/api/user/sync', \App\Controllers\Api\SyncController::class, 'sync');

    // Pokemon API routes
    $router->get('/api/pokemon', \App\Controllers\Api\PokemonApiController::class, 'index');
    $router->get('/api/pokemon/{id}', \App\Controllers\Api\PokemonApiController::class, 'show');
    $router->post('/api/pokemon/catch', \App\Controllers\Api\PokemonApiController::class, 'catch');
    $router->get('/api/user/{id}/pokemon', \App\Controllers\Api\PokemonApiController::class, 'userPokemon');

    // Admin routes – Pokémon
    $router->get('/admin/pokemon', \App\Controllers\Admin\PokemonController::class, 'index');
    $router->post('/admin/pokemon', \App\Controllers\Admin\PokemonController::class, 'store');

    // Admin routes – Utilisateurs (page HTML + API temps réel)
    $router->get('/admin/users', \App\Controllers\Admin\UsersController::class, 'index');
    $router->get('/admin/api/users', \App\Controllers\Admin\UsersController::class, 'apiUsers');
    $router->get('/admin/api/users/{id}/inventory', \App\Controllers\Admin\UsersController::class, 'apiInventory');
    $router->post('/admin/api/users/{id}/stats', \App\Controllers\Admin\UsersController::class, 'updateStats');
    $router->post('/admin/api/users/{id}/inventory', \App\Controllers\Admin\UsersController::class, 'updateInventory');

    $router->dispatch();
} catch (Exception $e) {
    http_response_code(500);
    echo "Erreur critique : " . $e->getMessage();
}
