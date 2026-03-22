<?php

namespace App\Core;

class View
{
    public function __construct(private readonly string $basePath)
    {
    }

    public function render(string $template, array $data = []): void
    {
        extract($data, EXTR_SKIP);
        $viewPath = $this->basePath . '/' . $template . '.php';
        require $viewPath;
    }
}
