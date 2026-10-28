<?php
declare(strict_types=1);
session_start();
$configFile = dirname(__DIR__) . '/config.php';
if (!file_exists($configFile)) {
    http_response_code(500);
    exit('Configuration missing. Copy config.example.php to config.php and configure the database.');
}
$config = require $configFile;
try {
    $pdo = new PDO(
        "mysql:host={$config['db_host']};port={$config['db_port']};dbname={$config['db_name']};charset=utf8mb4",
        $config['db_user'], $config['db_pass'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, PDO::ATTR_EMULATE_PREPARES => false]
    );
} catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Unable to connect to the database. Check config.php and ensure MySQL is running.');
}
function e(mixed $value): string { return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
function redirect(string $url): never { header('Location: ' . $url); exit; }
function csrf_token(): string { if (empty($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(32)); return $_SESSION['csrf']; }
function verify_csrf(): void {
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && !hash_equals($_SESSION['csrf'] ?? '', (string)($_POST['csrf'] ?? ''))) {
        http_response_code(403); exit('Invalid form token. Return to the form and try again.');
    }
}
function flash(string $type, string $message): void { $_SESSION['flash'] = ['type'=>$type, 'message'=>$message]; }
function take_flash(): ?array { $f = $_SESSION['flash'] ?? null; unset($_SESSION['flash']); return $f; }
function require_login(): void { if (empty($_SESSION['user_id'])) redirect('login.php'); }
function log_activity(PDO $pdo, string $action, ?int $applicantId = null, string $details = ''): void {
    $stmt=$pdo->prepare('INSERT INTO audit_logs (user_id, applicant_id, action, details, ip_address) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$_SESSION['user_id'] ?? null, $applicantId, $action, mb_substr($details,0,250), $_SERVER['REMOTE_ADDR'] ?? null]);
}
