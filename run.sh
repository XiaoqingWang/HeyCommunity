#!/bin/bash

echo '################'
pwd
cd /app/backend
pwd

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
    echo 'run migrate'
    # php artisan migrate:refresh --seed
else
    echo 'not run migrate'
fi
