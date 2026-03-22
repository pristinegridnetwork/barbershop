<?php

namespace App\Services;

class BillingService
{
    public static function planFeatures(string $planSlug): array
    {
        foreach (MockDataService::plans() as $plan) {
            if ($plan['slug'] === $planSlug) {
                return $plan;
            }
        }

        return MockDataService::plans()[0];
    }

    public static function yearlyPrice(float $monthly, int $discountPercentage): float
    {
        return round(($monthly * 12) * ((100 - $discountPercentage) / 100), 2);
    }

    public static function featureGate(string $planSlug): array
    {
        return match ($planSlug) {
            'standard' => ['profiles' => 5, 'scheduled_posts' => 100, 'enterprise' => false, 'analytics_depth' => 'basic'],
            'professional' => ['profiles' => 15, 'scheduled_posts' => 350, 'enterprise' => false, 'analytics_depth' => 'advanced'],
            'advanced' => ['profiles' => PHP_INT_MAX, 'scheduled_posts' => PHP_INT_MAX, 'enterprise' => false, 'analytics_depth' => 'full'],
            'enterprise' => ['profiles' => PHP_INT_MAX, 'scheduled_posts' => PHP_INT_MAX, 'enterprise' => true, 'analytics_depth' => 'full+'],
            default => ['profiles' => 5, 'scheduled_posts' => 100, 'enterprise' => false, 'analytics_depth' => 'basic'],
        };
    }
}
