<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | This configuration determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'], // Define the paths you want to enable CORS for, like API routes.

    'allowed_methods' => ['*'], // Allow all HTTP methods (GET, POST, PUT, DELETE, etc.).

    'allowed_origins' => ['*'], // Allow all origins or specify certain origins, e.g., 'http://localhost:4200'

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'], // Allow all headers or specify which headers can be used.

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false, // Set to true if cookies or credentials are needed for cross-origin requests.

];
