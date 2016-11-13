#!/bin/bash

echo '################################';
env

if [ -n "$MYSQL_PORT_3306_TCP" ]; then
    echo 'run migrate'
    php artisan migrate:refresh --seed
else
    echo 'not run migrate'
fi


## apache2 foreground
apache2-foreground
