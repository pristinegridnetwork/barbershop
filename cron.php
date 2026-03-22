<?php

declare(strict_types=1);

require __DIR__ . '/app/bootstrap.php';

use App\Services\CronSimulationService;

header('Content-Type: text/plain');

$result = CronSimulationService::run();

echo "SocialFlow cron simulation\n";
foreach ($result as $task => $count) {
    echo sprintf("- %s: %s\n", $task, $count);
}
