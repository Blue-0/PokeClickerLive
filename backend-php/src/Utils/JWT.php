<?php
namespace App\Utils;

/**
 * JWT Utility Class
 * Simple JWT implementation using HS256 algorithm
 */
class JWT
{
    private static ?string $secret = null;

    /**
     * Get the JWT secret from environment
     */
    private static function getSecret(): string
    {
        if (self::$secret === null) {
            self::$secret = defined('JWT_SECRET') ? JWT_SECRET : 'default_secret_change_me';
        }
        return self::$secret;
    }

    /**
     * Base64 URL encode (JWT-safe encoding)
     */
    private static function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    /**
     * Base64 URL decode
     */
    private static function base64UrlDecode(string $data): string
    {
        $padding = 4 - (strlen($data) % 4);
        if ($padding !== 4) {
            $data .= str_repeat('=', $padding);
        }
        return base64_decode(strtr($data, '-_', '+/'));
    }

    /**
     * Encode/Generate a JWT token
     * 
     * @param array $payload Data to encode in the token
     * @param int $expiryHours Token validity in hours (default: 24)
     * @return string The JWT token
     */
    public static function encode(array $payload, int $expiryHours = 24): string
    {
        $header = [
            'alg' => 'HS256',
            'typ' => 'JWT'
        ];

        // Add standard claims
        $payload['iat'] = time();
        $payload['exp'] = time() + ($expiryHours * 3600);

        $headerEncoded = self::base64UrlEncode(json_encode($header));
        $payloadEncoded = self::base64UrlEncode(json_encode($payload));

        $signature = hash_hmac('sha256', "$headerEncoded.$payloadEncoded", self::getSecret(), true);
        $signatureEncoded = self::base64UrlEncode($signature);

        return "$headerEncoded.$payloadEncoded.$signatureEncoded";
    }

    /**
     * Decode and validate a JWT token
     * 
     * @param string $token The JWT token to decode
     * @return array|null The payload if valid, null otherwise
     */
    public static function decode(string $token): ?array
    {
        $parts = explode('.', $token);

        if (count($parts) !== 3) {
            return null;
        }

        [$headerEncoded, $payloadEncoded, $signatureEncoded] = $parts;

        // Verify signature
        $expectedSignature = hash_hmac('sha256', "$headerEncoded.$payloadEncoded", self::getSecret(), true);
        $expectedSignatureEncoded = self::base64UrlEncode($expectedSignature);

        if (!hash_equals($expectedSignatureEncoded, $signatureEncoded)) {
            return null;
        }

        // Decode payload
        $payload = json_decode(self::base64UrlDecode($payloadEncoded), true);

        if (!$payload) {
            return null;
        }

        // Check expiration
        if (isset($payload['exp']) && $payload['exp'] < time()) {
            return null;
        }

        return $payload;
    }

    /**
     * Get payload from token without validation (for debugging)
     * 
     * @param string $token The JWT token
     * @return array|null The payload or null if invalid format
     */
    public static function getPayload(string $token): ?array
    {
        $parts = explode('.', $token);

        if (count($parts) !== 3) {
            return null;
        }

        return json_decode(self::base64UrlDecode($parts[1]), true);
    }

    /**
     * Extract token from Authorization header
     * 
     * @return string|null The token or null if not present
     */
    public static function getTokenFromHeader(): ?string
    {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';

        if (preg_match('/Bearer\s+(.+)$/i', $authHeader, $matches)) {
            return $matches[1];
        }

        return null;
    }

    /**
     * Validate token from Authorization header and return payload
     * 
     * @return array|null The payload if valid, null otherwise
     */
    public static function validateFromHeader(): ?array
    {
        $token = self::getTokenFromHeader();

        if (!$token) {
            return null;
        }

        return self::decode($token);
    }
}
