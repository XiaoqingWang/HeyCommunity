#!/bin/bash

echo '################'
pwd
ls -la

git submodule update --init

cd backend
pwd
ls -la

composer install
chmod -R 0777 .

cp ../.env.daoCloud .env
php artisan key:generate

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
    echo 'run migrate'
    php artisan migrate:refresh --seed
else
    echo 'not run migrate'
fi
