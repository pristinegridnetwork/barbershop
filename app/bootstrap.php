<?php

declare(strict_types=1);

$config = require __DIR__ . '/Config/config.php';
date_default_timezone_set($config['app']['timezone']);

spl_autoload_register(static function (string $class): void {
    $prefix = 'App\\';
    if (strpos($class, $prefix) !== 0) {
        return;
    }

    $relativeClass = substr($class, strlen($prefix));
    $path = __DIR__ . '/' . str_replace('\\', '/', $relativeClass) . '.php';

    if (is_file($path)) {
        require $path;
    }
});

use App\Core\Session;
use App\Core\View;

Session::start($config);

return [
    'config' => $config,
    'view' => new View(__DIR__ . '/../views'),
];
