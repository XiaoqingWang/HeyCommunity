#!/bin/bash


##
##
echo '################################';

if [ -n "$MYSQL_PORT_3306_TCP_PORT" ]; then

  dbVal="
    \n\n
    export DB_HOST=$MYSQL_PORT_3306_TCP_ADDR\n
    export DB_PORT=$MYSQL_PORT_3306_TCP_PORT\n
  ";

  if [ -n "$MYSQL_INSTANCE_NAME" ]; then
    dbVal=$dbVal"
      export DB_DATABASE=$MYSQL_INSTANCE_NAME\n
      export DB_USERNAME=$MYSQL_USERNAME\n
      export DB_PASSWORD=$MYSQL_PASSWORD\n
    "
  else
    dbVal=$dbVal"
      export DB_DATABASE=$MYSQL_ENV_MYSQL_DATABASE\n
      export DB_USERNAME=root\n
      export DB_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD\n
    "
  fi

  echo -e $dbVal
  echo -e $dbVal >> ~/.bashrc
  source ~/.bashrc

  php /app/backend/artisan migrate:refresh --seed

  echo 'With the database and perform the migration'
else
  echo 'There is no database'
fi


##
##
echo '### debug'
env


##
## apache2 foreground
apache2-foreground
