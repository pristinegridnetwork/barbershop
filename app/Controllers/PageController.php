<?php

namespace App\Controllers;

use App\Core\Csrf;
use App\Core\Session;
use App\Core\View;
use App\Services\AuthService;
use App\Services\AutomationService;
use App\Services\MockDataService;

class PageController
{
    public function __construct(private readonly View $view, private readonly array $config)
    {
    }

    public function home(): void
    {
        $this->view->render('pages/home', [
            'appName' => $this->config['app']['name'],
            'plans' => MockDataService::plans(),
            'dashboard' => MockDataService::dashboard(),
            'analytics' => MockDataService::analyticsSeries(),
            'suggestions' => AutomationService::schedulingSuggestions(),
            'user' => AuthService::user(),
            'flash' => Session::flash('status'),
            'csrf' => Csrf::token(),
        ]);
    }
}
