<?php

/**
 * ID-Shaydi Card Maker — Standalone Migration & Cache Trigger
 * Run from browser: https://admin.idshaydi.in/migrate_helper.php
 */

require __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

header('Content-Type: application/json');

try {
    Illuminate\Support\Facades\Artisan::call('migrate', ['--force' => true]);
    $migrateOutput = Illuminate\Support\Facades\Artisan::output();

    Illuminate\Support\Facades\Artisan::call('optimize:clear');
    $clearOutput = Illuminate\Support\Facades\Artisan::output();

    echo json_encode([
        'status' => true,
        'message' => 'Migrations and cache clearing executed successfully on live server!',
        'migrate_output' => trim($migrateOutput),
        'cache_output' => trim($clearOutput),
    ], JSON_PRETTY_PRINT);
} catch (\Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'status' => false,
        'error' => $e->getMessage(),
    ], JSON_PRETTY_PRINT);
}
