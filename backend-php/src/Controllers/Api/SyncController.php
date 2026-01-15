<?php
namespace App\Controllers\Api;

use App\Controllers\Controller;
use App\Utils\JWT;

class SyncController extends Controller
{
    /**
     * POST /api/user/sync
     * Sync local progress with the cloud (Stub)
     */
    public function sync(): void
    {
        // 1. Auth Check
        $payload = JWT::validateFromHeader();
        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        // $userId = $payload['user_id'];
        // $input = $this->getJsonInput(); 

        // Stub response
        $this->success([
            'server_timestamp' => time(),
            'cloud_data' => null // No cloud data yet
        ]);
    }
}
