#!/usr/bin/env bash
source ./.env.sh

# specifies the MySQL port.
port=`sed '/^DOCKER_PORT=/!d;s/.*=//' ${env}`
[[ ! ${port} ]] && read -e -p "Enter the MySQL port: (3306) " port
[[ ! ${port} ]] && port=3306

# specifies the password that will be set for the MySQL root superuser account.
root_password=`sed '/^MYSQL_ROOT_PASSWORD=/!d;s/.*=//' ${env}`
[[ ! ${root_password} ]] && read -e -p "Enter the MySQL root password: " root_password

# specifies other environment Variables.
mysql_database=`sed '/^MYSQL_DATABASE=/!d;s/.*=//' ${env}`
mysql_user=`sed '/^MYSQL_USER=/!d;s/.*=//' ${env}`
mysql_password=`sed '/^MYSQL_PASSWORD=/!d;s/.*=//' ${env}`
mysql_empty_password=`sed '/^MYSQL_ALLOW_EMPTY_PASSWORD=/!d;s/.*=//' ${env}`
mysql_random_password=`sed '/^MYSQL_RANDOM_ROOT_PASSWORD=/!d;s/.*=//' ${env}`
mysql_onetime_password=`sed '/^MYSQL_ONETIME_PASSWORD=/!d;s/.*=//' ${env}`
[[ ! ${root_password} ]] && mysql_empty_password="yes" && unset mysql_random_password

# remove mysql8.0 container
if [ "$(echo "$(docker ps -aq -f name=${name} --format "{{.Names}}")" | grep -i "^${name}$")" ]; then
  docker rm -f ${name} > /dev/null
fi

# build mysql8.0-db container
if [ ! "$(docker ps -q -f name=${name}-db)" ]; then
  if [ ! "$(docker ps -aq -f status=exited -f name=${name}-db)" ]; then
    docker run \
      -v ${volume}/mysql/data:/var/lib/mysql \
      --name ${name}-db mysql:8.0 \
      echo "Data-only container for mysql" > /dev/null

    echo -e "Created \033[4m${name}-db\033[0m \033[32mSuccessfully\033[0m!"
  fi
fi

# build mysql8.0 container
docker run --restart=always \
  --volumes-from ${name}-db \
  -v ${volume}/mysql/conf:/etc/mysql/conf.d \
  -v ${volume}/mysql/logs:/log \
  -v ${volume}/mysql/share:/share \
  -p ${port}:3306 \
  -e MYSQL_ROOT_PASSWORD=${root_password} \
  -e MYSQL_DATABASE=${mysql_database} \
  -e MYSQL_USER=${mysql_user} \
  -e MYSQL_PASSWORD=${mysql_password} \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=${mysql_empty_password} \
  -e MYSQL_RANDOM_ROOT_PASSWORD=${mysql_random_password} \
  -e MYSQL_ONETIME_PASSWORD=${mysql_onetime_password} \
  --name ${name} -d mysql:8.0 > /dev/null

echo -e "Created \033[4m${name}\033[0m \033[32mSuccessfully\033[0m!"
