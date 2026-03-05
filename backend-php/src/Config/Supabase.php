<?php
namespace App\Config;

/**
 * Supabase Client for PHP
 * Uses the REST API with API Keys
 */
class Supabase
{
    private static $instance = null;
    private $url;
    private $key;
    private $serviceKey;

    private function __construct()
    {
        $this->url = SUPABASE_URL;
        $this->key = SUPABASE_KEY;
        $this->serviceKey = defined('SUPABASE_SERVICE_KEY') ? SUPABASE_SERVICE_KEY : null;
    }

    public static function getInstance()
    {
        if (self::$instance == null) {
            self::$instance = new Supabase();
        }
        return self::$instance;
    }

    /**
     * Make HTTP request to Supabase REST API
     */
    private function request($method, $endpoint, $data = null, $useServiceKey = false)
    {
        $url = rtrim($this->url, '/') . '/rest/v1/' . ltrim($endpoint, '/');

        $headers = [
            'Content-Type: application/json',
            'apikey: ' . ($useServiceKey && $this->serviceKey ? $this->serviceKey : $this->key),
            'Authorization: Bearer ' . ($useServiceKey && $this->serviceKey ? $this->serviceKey : $this->key),
            'Prefer: return=representation'
        ];

        $ch = \curl_init();
        \curl_setopt($ch, CURLOPT_URL, $url);
        \curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        \curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        \curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // Disable for self-hosted

        switch (strtoupper($method)) {
            case 'POST':
                \curl_setopt($ch, CURLOPT_POST, true);
                if ($data) {
                    \curl_setopt($ch, CURLOPT_POSTFIELDS, \json_encode($data));
                }
                break;
            case 'PATCH':
                \curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
                if ($data) {
                    \curl_setopt($ch, CURLOPT_POSTFIELDS, \json_encode($data));
                }
                break;
            case 'DELETE':
                \curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
                break;
            case 'GET':
            default:
                // GET is default
                break;
        }

        $response = \curl_exec($ch);
        $httpCode = \curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = \curl_error($ch);
        \curl_close($ch);

        if ($error) {
            return ['error' => $error, 'code' => 0];
        }

        return [
            'data' => \json_decode($response, true),
            'code' => $httpCode
        ];
    }

    /**
     * SELECT query - Get data from a table
     * @param string   $table   Table name
     * @param string   $select  Columns to select (default: *)
     * @param array    $filters Filters in format ['column' => 'eq.value']
     * @param int|null $limit   Maximum rows (PostgREST limit param)
     * @param int|null $offset  Row offset for pagination (PostgREST offset param)
     */
    public function from($table, $select = '*', $filters = [], $limit = null, $offset = null)
    {
        $query = $table . '?select=' . urlencode($select);

        foreach ($filters as $column => $value) {
            $query .= '&' . urlencode($column) . '=' . urlencode($value);
        }

        if ($limit !== null) {
            $query .= '&limit=' . (int) $limit;
        }

        if ($offset !== null) {
            $query .= '&offset=' . (int) $offset;
        }

        return $this->request('GET', $query);
    }

    /**
     * INSERT query - Add data to a table
     */
    public function insert($table, $data, $useServiceKey = false)
    {
        return $this->request('POST', $table, $data, $useServiceKey);
    }

    /**
     * UPDATE query - Update data in a table
     * @param string $table Table name
     * @param array $data Data to update
     * @param array $filters Filters to identify rows (e.g., ['id' => 'eq.1'])
     */
    public function update($table, $data, $filters = [], $useServiceKey = false)
    {
        $query = $table . '?';
        $filterParts = [];
        foreach ($filters as $column => $value) {
            $filterParts[] = urlencode($column) . '=' . urlencode($value);
        }
        $query .= implode('&', $filterParts);

        return $this->request('PATCH', $query, $data, $useServiceKey);
    }

    /**
     * DELETE query - Remove data from a table
     * @param string $table Table name
     * @param array $filters Filters to identify rows
     */
    public function delete($table, $filters = [], $useServiceKey = false)
    {
        $query = $table . '?';
        $filterParts = [];
        foreach ($filters as $column => $value) {
            $filterParts[] = urlencode($column) . '=' . urlencode($value);
        }
        $query .= implode('&', $filterParts);

        return $this->request('DELETE', $query, null, $useServiceKey);
    }

    /**
     * Test the connection to Supabase
     */
    public function testConnection()
    {
        $ch = \curl_init();
        \curl_setopt($ch, CURLOPT_URL, rtrim($this->url, '/') . '/rest/v1/');
        \curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        \curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'apikey: ' . $this->key,
            'Authorization: Bearer ' . $this->key
        ]);
        \curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        \curl_setopt($ch, CURLOPT_TIMEOUT, 10);

        $response = \curl_exec($ch);
        $httpCode = \curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = \curl_error($ch);
        \curl_close($ch);

        if ($error) {
            return ['success' => false, 'error' => $error];
        }

        return [
            'success' => $httpCode >= 200 && $httpCode < 400,
            'code' => $httpCode,
            'response' => \json_decode($response, true)
        ];
    }
}
