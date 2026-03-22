<?php

namespace App\Services;

class AutomationService
{
    public static function schedulingSuggestions(): array
    {
        return [
            ['time' => '09:00', 'reason' => 'Highest LinkedIn CTR for B2B audience.'],
            ['time' => '12:30', 'reason' => 'Instagram lunch-hour engagement spike.'],
            ['time' => '18:15', 'reason' => 'X conversation volume peaks after work hours.'],
        ];
    }

    public static function aiReplyPreview(string $message): string
    {
        return 'Thanks for reaching out about "' . trim($message) . '". Our team has logged your request and will follow up shortly with next steps.';
    }
}
