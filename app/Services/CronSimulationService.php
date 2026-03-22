<?php

namespace App\Services;

class CronSimulationService
{
    public static function run(): array
    {
        return [
            'subscriptions_expired' => 1,
            'renewal_reminders_sent' => 3,
            'queued_posts_processed' => 42,
            'scheduled_reports_sent' => 5,
        ];
    }
}
