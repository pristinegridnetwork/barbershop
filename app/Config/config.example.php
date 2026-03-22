<?php

return [
    'app' => [
        'name' => 'SocialFlow SaaS',
        'base_url' => 'http://localhost:8000',
        'timezone' => 'UTC',
        'session_name' => 'socialflow_session',
    ],
    'db' => [
        'driver' => 'mysql',
        'host' => '127.0.0.1',
        'port' => 3306,
        'database' => 'socialflow',
        'username' => 'root',
        'password' => '',
        'charset' => 'utf8mb4',
    ],
    'security' => [
        'csrf_key' => '_csrf',
    ],
    'billing' => [
        'yearly_discount_percentage' => 18,
        'trial_days' => 14,
    ],
];
