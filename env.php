<?php
return array(
    'backend' =>
        array(
            'frontName' => 'admin',
        ),
    'crypt' =>
        array(
            'key' => '730afa41f9bbc65b87e1827204c0eff5',
        ),
    'session' =>
        array(
            'save' => 'files',
        ),
    'db' =>
        array(
            'table_prefix' => '',
            'connection' =>
                array(
                    'default' =>
                        array(
                            'host' => getenv('MYSQL_HOST'),
                            'dbname' => getenv('MYSQL_DATABASE'),
                            'username' => getenv('MYSQL_USER'),
                            'password' => getenv('MYSQL_PASSWORD'),
                            'active' => '1',
                        ),
                ),
        ),
    'resource' =>
        array(
            'default_setup' =>
                array(
                    'connection' => 'default',
                ),
        ),
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'default',
    'cache_types' =>
        array(
            'config' => 0,
            'layout' => 0,
            'block_html' => 0,
            'collections' => 0,
            'reflection' => 0,
            'db_ddl' => 0,
            'eav' => 0,
            'customer_notification' => 0,
            'full_page' => 0,
            'config_integration' => 0,
            'config_integration_api' => 0,
            'translate' => 0,
            'config_webservice' => 0,
        ),
    'install' =>
        array(
            'date' => 'Mon, 23 Oct 2017 22:56:24 +0000',
        ),
);
