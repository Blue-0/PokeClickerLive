<?php
namespace App\Models;

/**
 * AuthLog Model
 * Logs all authentication events for security and auditing
 */
class AuthLog extends Model
{
    protected static string $table = 'auth_logs';
    protected static string $primaryKey = 'id';

    /**
     * Log an authentication event
     * 
     * @param int|string|null $userId User ID (null for failed attempts)
     * @param string $email Email used
     * @param string $action Action type (register, login, login_failed, logout)
     * @return array|null
     */
    public static function log(?int $userId, string $email, string $action): ?array
    {
        return self::create([
            'user_id' => $userId,
            'email' => $email,
            'action' => $action,
            'ip_address' => self::getClientIP(),
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown',
            'timestamp' => date('c')
        ], true);
    }

    /**
     * Log a successful registration
     */
    public static function logRegister(int $userId, string $email): ?array
    {
        return self::log($userId, $email, 'register');
    }

    /**
     * Log a successful login
     */
    public static function logLogin(int $userId, string $email): ?array
    {
        return self::log($userId, $email, 'login');
    }

    /**
     * Log a failed login attempt
     */
    public static function logLoginFailed(string $email): ?array
    {
        return self::log(null, $email, 'login_failed');
    }

    /**
     * Log a logout
     */
    public static function logLogout(int $userId, string $email): ?array
    {
        return self::log($userId, $email, 'logout');
    }

    /**
     * Get client IP address
     */
    private static function getClientIP(): string
    {
        // Check for forwarded IP (proxy/load balancer)
        if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            return trim($ips[0]);
        }

        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            return $_SERVER['HTTP_CLIENT_IP'];
        }

        return $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
    }

    /**
     * Get recent logs for a user
     */
    public static function getByUserId(int|string $userId, int $limit = 20): array
    {
        return self::where('user_id', 'eq', $userId);
    }

    /**
     * Get recent failed attempts for an email
     */
    public static function getFailedAttempts(string $email, int $minutes = 30): array
    {
        // Note: For full implementation, add time-based filtering via Supabase
        $logs = self::where('email', 'eq', $email);
        return array_filter($logs, fn($log) => $log['action'] === 'login_failed');
    }
}
