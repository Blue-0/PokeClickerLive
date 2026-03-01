<?php
namespace App\Controllers\Api;

use App\Controllers\Controller;
use App\Models\User;
use App\Models\AuthLog;
use App\Utils\JWT;

/**
 * Authentication Controller
 * Handles user registration and login with JWT token generation
 */
class AuthController extends Controller
{
    /**
     * POST /api/auth/register
     * Register a new user
     * Body: { "username": string, "email": string, "password": string }
     */
    public function register(): void
    {
        $input = $this->getJsonInput();

        // Validate required fields
        if (!$input || !isset($input['username']) || !isset($input['email']) || !isset($input['password'])) {
            $this->error('Username, email and password are required', 400);
            return;
        }

        $username = trim($input['username']);
        $email = trim(strtolower($input['email']));
        $password = $input['password'];

        // Validate username
        if (strlen($username) < 3 || strlen($username) > 50) {
            $this->error('Username must be between 3 and 50 characters', 400);
            return;
        }

        if (!preg_match('/^[a-zA-Z0-9_]+$/', $username)) {
            $this->error('Username can only contain letters, numbers and underscores', 400);
            return;
        }

        // Validate email
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('Invalid email format', 400);
            return;
        }

        // Validate password
        if (strlen($password) < 6) {
            $this->error('Password must be at least 6 characters', 400);
            return;
        }

        // Check if email already exists
        $existingEmail = User::findByEmail($email);
        if ($existingEmail) {
            $this->error('Email already exists', 400);
            return;
        }

        // Check if username already exists
        $existingUsername = User::findByUsername($username);
        if ($existingUsername) {
            $this->error('Username already taken', 400);
            return;
        }

        // Create user
        $result = User::registerWithError($username, $email, $password);

        if (!$result['success']) {
            $this->error('Failed to create user: ' . $result['error'], 500);
            return;
        }

        $user = $result['data'];

        // Generate JWT token – role is included so API guards can authorise admin actions
        $token = JWT::encode([
            'user_id'  => $user['id'],
            'username' => $user['username'],
            'email'    => $user['email'],
            'role'     => $user['role'] ?? 'player',
        ]);

        // Log registration
        AuthLog::logRegister($user['id'], $email);

        // Return success with token
        $this->success([
            'user' => User::toPublic($user),
            'token' => $token
        ], 'Registration successful');
    }

    /**
     * POST /api/auth/login
     * Login a user
     * Body: { "email": string, "password": string }
     */
    public function login(): void
    {
        $input = $this->getJsonInput();

        // Validate required fields
        if (!$input || !isset($input['email']) || !isset($input['password'])) {
            $this->error('Email and password are required', 400);
            return;
        }

        $email = trim(strtolower($input['email']));
        $password = $input['password'];

        // Find user by email
        $user = User::findByEmail($email);

        if (!$user) {
            AuthLog::logLoginFailed($email);
            $this->error('Invalid credentials', 401);
            return;
        }

        // Verify password
        if (!User::verifyPassword($user, $password)) {
            AuthLog::logLoginFailed($email);
            $this->error('Invalid credentials', 401);
            return;
        }

        // Generate JWT token – role is included so API guards can authorise admin actions
        $token = JWT::encode([
            'user_id'  => $user['id'],
            'username' => $user['username'],
            'email'    => $user['email'],
            'role'     => $user['role'] ?? 'player',
        ]);

        // Log successful login
        AuthLog::logLogin($user['id'], $email);

        // Return success with token
        $this->success([
            'user' => User::toPublic($user),
            'token' => $token
        ], 'Login successful');
    }

    /**
     * GET /api/auth/me
     * Get current authenticated user (requires JWT)
     */
    public function me(): void
    {
        $payload = JWT::validateFromHeader();

        if (!$payload) {
            $this->error('Unauthorized', 401);
            return;
        }

        $user = User::find($payload['user_id']);

        if (!$user) {
            $this->error('User not found', 404);
            return;
        }

        $this->success(User::toPublic($user));
    }
}
