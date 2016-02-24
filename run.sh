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

cp ../env.daoCloud .env
php artisan key:generate
php artisan migrate:refresh --seed
