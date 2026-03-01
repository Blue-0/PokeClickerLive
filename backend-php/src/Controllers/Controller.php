<?php
namespace App\Controllers;

use App\Utils\JWT;

/**
 * Base Controller class
 * Provides common functionality for all controllers
 */
class Controller
{
    /**
     * Send a JSON response
     */
    protected function json(array $data, int $statusCode = 200): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode($data);
    }

    /**
     * Send a success response
     */
    protected function success(mixed $data = null, string $message = 'Success'): void
    {
        $response = ['status' => 'success', 'message' => $message];

        if ($data !== null) {
            $response['data'] = $data;
        }

        $this->json($response);
    }

    /**
     * Send an error response
     */
    protected function error(string $message, int $statusCode = 400, ?array $errors = null): void
    {
        $response = ['status' => 'error', 'message' => $message];

        if ($errors !== null) {
            $response['errors'] = $errors;
        }

        $this->json($response, $statusCode);
    }

    /**
     * Get JSON input from request body
     */
    protected function getJsonInput(): ?array
    {
        $input = file_get_contents('php://input');
        return json_decode($input, true);
    }

    /**
     * Protect admin HTML pages with HTTP Basic Authentication.
     *
     * Credentials are stored in environment variables:
     *   ADMIN_USER          – admin username
     *   ADMIN_PASSWORD_HASH – bcrypt hash of the admin password
     *                         (generate with: php -r "echo password_hash('pass', PASSWORD_DEFAULT);")
     *
     * Uses password_verify() (bcrypt) – same protection as user passwords,
     * ensuring the plain-text password is never stored anywhere.
     */
    protected function requireAdminBasicAuth(): void
    {
        $authUser     = $_SERVER['PHP_AUTH_USER'] ?? '';
        $authPass     = $_SERVER['PHP_AUTH_PW']   ?? '';
        $expectedUser = getenv('ADMIN_USER')          ?: 'admin';
        $expectedHash = getenv('ADMIN_PASSWORD_HASH') ?: '';

        // Reject immediately if the hash is not configured or credentials are wrong.
        // password_verify() uses a timing-safe comparison (bcrypt).
        $authorized = $expectedHash
            && $authUser === $expectedUser
            && password_verify($authPass, $expectedHash);

        if (!$authorized) {
            header('WWW-Authenticate: Basic realm="Sinnoh Clicker Admin"');
            http_response_code(401);
            echo '<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8">'
               . '<title>Accès refusé</title></head><body>'
               . '<h1>401 – Accès non autorisé</h1>'
               . '<p>Identifiants administrateur requis pour accéder à ce panneau.</p>'
               . '</body></html>';
            exit;
        }
    }

    /**
     * Protect JSON API routes that require an admin role.
     *
     * The JWT payload must contain "role": "admin" (set at login time).
     * Returns true on success; emits a JSON error response and returns false otherwise.
     */
    protected function requireAdmin(): bool
    {
        $payload = JWT::validateFromHeader();

        if (!$payload) {
            $this->error('Unauthorized – valid JWT required', 401);
            return false;
        }

        if (($payload['role'] ?? '') !== 'admin') {
            $this->error('Forbidden – administrator role required', 403);
            return false;
        }

        return true;
    }
}
