<?php
namespace App\Models;

use App\Config\Supabase;

/**
 * Abstract Model class - Base for all models
 * Provides common CRUD operations via Supabase REST API
 */
abstract class Model
{
    protected static string $table = '';
    protected static string $primaryKey = 'id';
    protected Supabase $db;

    public function __construct()
    {
        $this->db = Supabase::getInstance();
    }

    /**
     * Get all records from the table
     */
    public static function all(string $select = '*'): array
    {
        $instance = new static();
        $result = $instance->db->from(static::$table, $select);

        if (isset($result['error'])) {
            return [];
        }

        return $result['data'] ?? [];
    }

    /**
     * Find a record by ID
     */
    public static function find(int|string $id, string $select = '*'): ?array
    {
        $instance = new static();
        $result = $instance->db->from(
            static::$table,
            $select,
            [static::$primaryKey => 'eq.' . $id]
        );

        if (isset($result['error']) || empty($result['data'])) {
            return null;
        }

        return $result['data'][0] ?? null;
    }

    /**
     * Find records by a specific column
     */
    public static function where(string $column, string $operator, mixed $value, string $select = '*'): array
    {
        $instance = new static();
        $filter = $column . '=' . $operator . '.' . $value;

        $result = $instance->db->from(
            static::$table,
            $select,
            [$column => $operator . '.' . $value]
        );

        if (isset($result['error'])) {
            return [];
        }

        return $result['data'] ?? [];
    }

    /**
     * Create a new record
     */
    public static function create(array $data, bool $useServiceKey = false): ?array
    {
        $instance = new static();
        $result = $instance->db->insert(static::$table, $data, $useServiceKey);

        if (isset($result['error']) || $result['code'] >= 400) {
            return null;
        }

        return $result['data'][0] ?? $result['data'] ?? null;
    }

    /**
     * Create a new record with error details
     * Returns ['success' => bool, 'data' => array|null, 'error' => string|null]
     */
    public static function createWithError(array $data, bool $useServiceKey = false): array
    {
        $instance = new static();
        $result = $instance->db->insert(static::$table, $data, $useServiceKey);

        if (isset($result['error']) || $result['code'] >= 400) {
            $errorMsg = $result['error'] ?? json_encode($result['data']) ?? 'Unknown error';
            return ['success' => false, 'data' => null, 'error' => $errorMsg, 'code' => $result['code'] ?? 0];
        }

        return ['success' => true, 'data' => $result['data'][0] ?? $result['data'] ?? null, 'error' => null];
    }

    /**
     * Update a record by ID
     */
    public static function update(int|string $id, array $data, bool $useServiceKey = false): ?array
    {
        $instance = new static();
        $result = $instance->db->update(
            static::$table,
            $data,
            [static::$primaryKey => 'eq.' . $id],
            $useServiceKey
        );

        if (isset($result['error']) || $result['code'] >= 400) {
            return null;
        }

        return $result['data'][0] ?? null;
    }

    /**
     * Delete a record by ID
     */
    public static function delete(int|string $id, bool $useServiceKey = false): bool
    {
        $instance = new static();
        $result = $instance->db->delete(
            static::$table,
            [static::$primaryKey => 'eq.' . $id],
            $useServiceKey
        );

        return !isset($result['error']) && $result['code'] < 400;
    }
}
