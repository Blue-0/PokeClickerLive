<?php
namespace App\Models;

/**
 * TransactionLog Model
 * Audit trail for all game actions (anti-cheat)
 */
class TransactionLog extends Model
{
    protected static string $table = 'transaction_logs';
    protected static string $primaryKey = 'id';

    // Transaction types
    public const TYPE_CLICK = 'click';
    public const TYPE_PURCHASE = 'purchase';
    public const TYPE_CATCH = 'catch';
    public const TYPE_UPGRADE = 'upgrade';
    public const TYPE_SALE = 'sale';
    public const TYPE_LOGIN = 'login';
    public const TYPE_REGISTER = 'register';

    /**
     * Log a transaction
     */
    public static function log(
        int|string $userId,
        string $type,
        ?int $amount = null,
        ?string $details = null,
        ?float $lat = null,
        ?float $lng = null
    ): ?array {
        $data = [
            'user_id' => $userId,
            'type' => $type,
            'created_at' => date('c')
        ];

        if ($amount !== null) {
            $data['amount'] = $amount;
        }

        if ($details !== null) {
            $data['details'] = $details;
        }

        if ($lat !== null && $lng !== null) {
            $data['latitude'] = $lat;
            $data['longitude'] = $lng;
        }

        return self::create($data, true);
    }

    /**
     * Get logs for a user
     */
    public static function getByUserId(int|string $userId, int $limit = 50): array
    {
        $instance = new static();
        $result = $instance->db->from(
            self::$table . '?order=created_at.desc&limit=' . $limit,
            '*',
            ['user_id' => 'eq.' . $userId]
        );

        return $result['data'] ?? [];
    }

    /**
     * Get logs by type
     */
    public static function getByType(string $type, int $limit = 100): array
    {
        $instance = new static();
        $result = $instance->db->from(
            self::$table . '?order=created_at.desc&limit=' . $limit,
            '*',
            ['type' => 'eq.' . $type]
        );

        return $result['data'] ?? [];
    }

    /**
     * Log a click action
     */
    public static function logClick(int|string $userId, int $earnings): ?array
    {
        return self::log($userId, self::TYPE_CLICK, $earnings, 'Click earnings');
    }

    /**
     * Log a purchase action
     */
    public static function logPurchase(int|string $userId, int $cost, string $itemName): ?array
    {
        return self::log($userId, self::TYPE_PURCHASE, -$cost, 'Purchased: ' . $itemName);
    }

    /**
     * Log a Pokémon catch
     */
    public static function logCatch(int|string $userId, int $pokemonId, int $cost, ?float $lat = null, ?float $lng = null): ?array
    {
        return self::log($userId, self::TYPE_CATCH, -$cost, 'Caught Pokemon #' . $pokemonId, $lat, $lng);
    }
}
