#!/bin/bash


##
##
echo -e "\n\n\n\n"
echo "###################################"
echo "## Deploy"

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

  echo -e "\n\n" >> /root/.bashrc
  echo "export DB_HOST=$DB_HOST" >> /root/.bashrc
  echo "export DB_PORT=$DB_PORT" >> /root/.bashrc
  echo "export DB_DATABASE=$DB_DATABASE" >> /root/.bashrc
  echo "export DB_USERNAME=$DB_USERNAME" >> /root/.bashrc
  echo "export DB_PASSWORD=$DB_PASSWORD" >> /root/.bashrc
  source /root/.bashrc

  until php artisan migrate:refresh --seed; do
    echo 'database migration retry ...'
    sleep 1.88;
  done
  echo 'With the database and perform the migration'
else
  echo 'There is no database'
fi


##
##
echo -e "\n\n\n\n"
echo "###################################"
echo "## Debug"
env
echo -e "\n\n\n\n"


##
##
exec "$@"
