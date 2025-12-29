<?php
namespace App\Controllers;

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
}
