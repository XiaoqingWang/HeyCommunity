#!/bin/bash


##
##
echo -e "\n\n\n\n### Deploy"

if [ -n "$MYSQL_PORT_3306_TCP_PORT" ]; then

  export DB_HOST=$MYSQL_PORT_3306_TCP_ADDR
  export DB_PORT=$MYSQL_PORT_3306_TCP_PORT

  if [ -n "$MYSQL_INSTANCE_NAME" ]; then
    export DB_DATABASE=$MYSQL_INSTANCE_NAME
    export DB_USERNAME=$MYSQL_USERNAME
    export DB_PASSWORD=$MYSQL_PASSWORD
  else
    export DB_DATABASE=$MYSQL_ENV_MYSQL_DATABASE
    export DB_USERNAME=root
    export DB_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD
  fi

  php artisan migrate:refresh --seed \
  && echo 'With the database and perform the migration' \
  || echo 'An error occurred'
else
  echo 'There is no database'
fi


##
##
echo -e "\n\n\n\n### Debug"
env


##
## apache2 foreground
apache2-foreground
