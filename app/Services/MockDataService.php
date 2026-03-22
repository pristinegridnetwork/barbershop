<?php

namespace App\Services;

class MockDataService
{
    public static function plans(): array
    {
        return [
            ['slug' => 'standard', 'name' => 'Standard', 'price_monthly' => 79, 'price_yearly' => 777.36, 'profiles' => 5, 'posts' => 100, 'analytics' => 'Basic analytics', 'features' => ['Unified inbox', 'Basic reporting', '5 social profiles', '14-day trial']],
            ['slug' => 'professional', 'name' => 'Professional', 'price_monthly' => 119, 'price_yearly' => 1170.96, 'profiles' => 15, 'posts' => 350, 'analytics' => 'Advanced analytics', 'features' => ['Bulk scheduling', 'Saved replies', 'Automation rules', 'PDF/CSV exports']],
            ['slug' => 'advanced', 'name' => 'Advanced', 'price_monthly' => 149, 'price_yearly' => 1466.16, 'profiles' => 'Unlimited', 'posts' => 'Unlimited', 'analytics' => 'Full analytics dashboard', 'features' => ['Listening tools', 'Sentiment analysis', '20 competitors', 'Scheduled reports']],
            ['slug' => 'enterprise', 'name' => 'Enterprise', 'price_monthly' => 0, 'price_yearly' => 0, 'profiles' => 'Unlimited', 'posts' => 'Unlimited', 'analytics' => 'Everything in Advanced', 'features' => ['SSO simulation', 'Salesforce sync', 'Proofpoint compliance', 'AI automation'], 'custom' => true],
        ];
    }

    public static function dashboard(): array
    {
        return [
            'kpis' => [
                ['label' => 'Connected Profiles', 'value' => 28, 'delta' => '+4 this month'],
                ['label' => 'Scheduled Posts', 'value' => 186, 'delta' => '42 in queue'],
                ['label' => 'Inbox SLA', 'value' => '91%', 'delta' => 'Avg reply 18m'],
                ['label' => 'MRR at Risk', 'value' => '$4,260', 'delta' => '3 renewals due'],
            ],
            'posts' => [
                ['platform' => 'Instagram', 'content' => 'Spring launch teaser with branded reels.', 'time' => '2026-03-23 09:00'],
                ['platform' => 'LinkedIn', 'content' => 'Executive thought leadership carousel.', 'time' => '2026-03-23 14:30'],
                ['platform' => 'X', 'content' => 'Live event countdown thread.', 'time' => '2026-03-24 11:15'],
            ],
            'messages' => [
                ['contact' => 'Ava Johnson', 'platform' => 'Facebook', 'tag' => 'Priority', 'sentiment' => 'Positive'],
                ['contact' => 'Noah Smith', 'platform' => 'Instagram', 'tag' => 'Billing', 'sentiment' => 'Neutral'],
                ['contact' => 'Liam Davis', 'platform' => 'LinkedIn', 'tag' => 'Escalation', 'sentiment' => 'Negative'],
            ],
            'billing' => [
                'plan' => 'Advanced Annual',
                'renewal_date' => '2026-04-05',
                'trial_days_left' => 0,
                'usage' => [
                    ['label' => 'Profiles used', 'value' => '28 / Unlimited'],
                    ['label' => 'Competitors tracked', 'value' => '12 / 20'],
                    ['label' => 'Automation rules', 'value' => '19 active'],
                ],
            ],
        ];
    }

    public static function analyticsSeries(): array
    {
        return [
            'labels' => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            'engagement' => [120, 165, 142, 210, 260, 225, 280],
            'mentions' => [30, 44, 39, 52, 64, 58, 70],
            'sentiment' => ['positive' => 61, 'neutral' => 28, 'negative' => 11],
        ];
    }
}
