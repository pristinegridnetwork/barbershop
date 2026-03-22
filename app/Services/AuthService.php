<?php

namespace App\Services;

use App\Core\Session;

class AuthService
{
    public static function demoUsers(): array
    {
        return [
            'admin@socialflow.test' => [
                'id' => 1,
                'name' => 'Ariana Admin',
                'role' => 'Admin',
                'plan' => 'Advanced',
                'password_hash' => password_hash('Password@123', PASSWORD_DEFAULT),
            ],
            'team@socialflow.test' => [
                'id' => 2,
                'name' => 'Taylor Team',
                'role' => 'Team Member',
                'plan' => 'Professional',
                'password_hash' => password_hash('Password@123', PASSWORD_DEFAULT),
            ],
            'enterprise@socialflow.test' => [
                'id' => 3,
                'name' => 'Elliot Enterprise',
                'role' => 'Enterprise User',
                'plan' => 'Enterprise',
                'password_hash' => password_hash('Password@123', PASSWORD_DEFAULT),
            ],
        ];
    }

    public static function attempt(string $email, string $password): bool
    {
        $users = self::demoUsers();
        $user = $users[strtolower($email)] ?? null;

        if (!$user || !password_verify($password, $user['password_hash'])) {
            return false;
        }

        Session::set('user', $user);
        return true;
    }

    public static function user(): ?array
    {
        return Session::get('user');
    }
}
