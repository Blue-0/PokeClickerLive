<?php
namespace App\Controllers\Admin;

use App\Controllers\Controller;
use App\Config\Supabase;

class DashboardController extends Controller
{
    public function index()
    {
        // Protect this page: only authenticated admins may access the dashboard.
        $this->requireAdminBasicAuth();

        $supabase = Supabase::getInstance();

        // Gather stats from Supabase
        $stats = [
            'users' => 0,
            'pokemon' => 0,
            'user_pokemon' => 0,
            'supabase_status' => false,
        ];

        // Test connection
        $connTest = $supabase->testConnection();
        $stats['supabase_status'] = $connTest['success'] ?? false;

        // Count users
        $result = $supabase->from('users', 'id');
        if (!isset($result['error']) && is_array($result['data'])) {
            $stats['users'] = count($result['data']);
        }

        // Count ref_pokemon
        $result = $supabase->from('ref_pokemon', 'id');
        if (!isset($result['error']) && is_array($result['data'])) {
            $stats['pokemon'] = count($result['data']);
        }

        // Count user_pokemon
        $result = $supabase->from('user_pokemon', 'id');
        if (!isset($result['error']) && is_array($result['data'])) {
            $stats['user_pokemon'] = count($result['data']);
        }

        require __DIR__ . '/../../Views/admin_dashboard.php';
    }
}
