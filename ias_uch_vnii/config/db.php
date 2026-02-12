<?php

return [
    'class' => 'yii\db\Connection',
    'dsn' => 'pgsql:host=localhost;port=5432;dbname=ias_vniic',
    'username' => 'postgres',
    'password' => '12345',
    'charset' => 'utf8',
    // Целевая схема в БД — tech_accounting.
    // По умолчанию Yii2 для PostgreSQL считает defaultSchema = public,
    // поэтому явно переназначаем схему, чтобы таблицы без префикса
    // (users, roles, tasks и т.п.) искались в tech_accounting.
    'schemaMap' => [
        'pgsql' => [
            'class' => \yii\db\pgsql\Schema::class,
            'defaultSchema' => 'tech_accounting',
        ],
    ],
    // Дополнительно фиксируем search_path для совместимости с SQL‑скриптами.
    'on afterOpen' => function ($event) {
        $event->sender->createCommand('SET search_path TO tech_accounting')->execute();
    },

    // Schema cache options (for production environment)
    //'enableSchemaCache' => true,
    //'schemaCacheDuration' => 60,
    //'schemaCache' => 'cache',
];


