<?php
namespace App\Utils;

use PDO;
use PDOException;

class Database {
    private static $pdo;

    public static function getConnection() {
        if (!self::$pdo) {
            $host = getenv('DB_HOST');
            $port = getenv('DB_PORT') ?: '5432';
            $db   = getenv('DB_NAME') ?: 'postgres';
            $user = getenv('DB_USER') ?: 'postgres';
            $pass = getenv('DB_PASSWORD');

            if (!$host || !$pass) {
                // Fallback for dev/test or error if crucial envs missing
                // In production Dokploy, these should be set
                if (!getenv('DB_HOST')) {
                     throw new PDOException("Database configuration missing (DB_HOST, DB_PASSWORD)");
                }
            }

            $dsn = "pgsql:host=$host;port=$port;dbname=$db";

            try {
                self::$pdo = new PDO($dsn, $user, $pass, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                ]);
            } catch (PDOException $e) {
                die("Erreur de connexion Admin : " . $e->getMessage());
            }
        }
        return self::$pdo;
    }
}
