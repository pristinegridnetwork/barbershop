<?php

declare(strict_types=1);

header('Content-Type: application/json');

require __DIR__ . '/../app/bootstrap.php';

use App\Services\AutomationService;
use App\Services\MockDataService;

$action = $_GET['action'] ?? 'snapshot';

$response = match ($action) {
    'snapshot' => ['status' => 'ok', 'data' => MockDataService::dashboard()],
    'analytics' => ['status' => 'ok', 'data' => MockDataService::analyticsSeries()],
    'ai-reply' => ['status' => 'ok', 'data' => ['reply' => AutomationService::aiReplyPreview($_POST['message'] ?? 'your message')]],
    'scheduler' => ['status' => 'ok', 'data' => AutomationService::schedulingSuggestions()],
    default => ['status' => 'error', 'message' => 'Unknown action'],
};

echo json_encode($response, JSON_PRETTY_PRINT);
