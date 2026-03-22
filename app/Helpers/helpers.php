<?php

use App\Core\Csrf;

function e(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function csrf_field(): string
{
    return '<input type="hidden" name="_csrf" value="' . Csrf::token() . '">';
}

function money(float $amount): string
{
    return '$' . number_format($amount, 2);
}
