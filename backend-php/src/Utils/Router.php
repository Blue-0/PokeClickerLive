<?php
namespace App\Utils;

class Router
{
    private $routes = [];

    public function get($path, $controller, $action)
    {
        $this->add('GET', $path, $controller, $action);
    }

    public function post($path, $controller, $action)
    {
        $this->add('POST', $path, $controller, $action);
    }

    public function add($method, $path, $controller, $action)
    {
        // Convert {param} to regex pattern
        $pattern = preg_replace('/\{(\w+)\}/', '(\d+)', $path);
        $pattern = '#^' . $pattern . '$#';

        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'pattern' => $pattern,
            'controller' => $controller,
            'action' => $action
        ];
    }

    public function dispatch()
    {
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $method = $_SERVER['REQUEST_METHOD'];

        foreach ($this->routes as $route) {
            // Check method first
            if ($route['method'] !== $method) {
                continue;
            }

            // Try regex match for dynamic routes
            if (preg_match($route['pattern'], $uri, $matches)) {
                $controllerClass = $route['controller'];
                $action = $route['action'];

                if (class_exists($controllerClass)) {
                    $controller = new $controllerClass();
                    if (method_exists($controller, $action)) {
                        // Remove full match, keep only captured groups
                        array_shift($matches);
                        // Call action with params
                        $controller->$action(...$matches);
                        return;
                    } else {
                        $this->sendError(500, "Method $action not found in $controllerClass");
                        return;
                    }
                } else {
                    $this->sendError(500, "Controller $controllerClass not found");
                    return;
                }
            }
        }

        $this->sendError(404, "Route not found");
    }

    private function sendError($code, $message)
    {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['error' => $message]);
    }
}

