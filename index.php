<?php

declare(strict_types=1);

$boot = require __DIR__ . '/app/bootstrap.php';
require __DIR__ . '/app/Helpers/helpers.php';

use App\Controllers\PageController;

$controller = new PageController($boot['view'], $boot['config']);
$controller->home();
