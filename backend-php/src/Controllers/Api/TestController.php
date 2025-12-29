<?php
namespace App\Controllers\Api;

use App\Config\Supabase;

class TestController
{

    public function ping()
    {
        // Test connexion Supabase
        $supabase = Supabase::getInstance();
        $result = $supabase->testConnection();

        header('Content-Type: application/json');

        if ($result['success']) {
            echo json_encode([
                'status' => 'success',
                'message' => 'API PokeClicker en ligne !',
                'supabase' => 'Connecté ✅',
                'http_code' => $result['code']
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => 'Échec de connexion à Supabase',
                'error' => $result['error'] ?? 'Unknown error',
                'http_code' => $result['code'] ?? 0
            ]);
        }
    }
}
