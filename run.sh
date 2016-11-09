#!/bin/bash

echo '################'
pwd
cd /app/backend
pwd

cp .env.example .env
php artisan key:generate

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
    echo 'run migrate'
    php artisan migrate:refresh --seed
else
    echo 'not run migrate'
fi
