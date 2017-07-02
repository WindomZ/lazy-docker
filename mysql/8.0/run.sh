#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2015,SC2154
[[ ! -r '.env-mysql.sh' ]] && (echo 'Not found .env-mysql file') && exit 1
source .env-mysql.sh

# remove mysql8.0 container
if docker ps -aq -f name="$name" --format "{{.Names}}" | grep -iq "^$name$"; then
  docker rm -f "$name" > /dev/null
fi

# run mysql8.0-db container
if ! docker ps -q -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
  if ! docker ps -aq -f status=exited -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
    docker run \
      -v "$volume/$name/data":/var/lib/mysql \
      --name "$name-db" mysql:8.0 \
      echo "Data-only container for mysql" > /dev/null

    echo -e "Created \033[4m$name-db\033[0m \033[32mSuccessfully\033[0m!"
  fi
fi

# run mysql8.0 container
docker run --restart=always \
  --volumes-from "$name-db" \
  -v "$volume/$name/conf":/etc/mysql/conf.d \
  -v "$volume/$name/logs":/log \
  -v "$volume/$name/share":/share \
  -p "$port":3306 \
  -e MYSQL_ROOT_PASSWORD="$root_password" \
  -e MYSQL_DATABASE="$mysql_database" \
  -e MYSQL_USER="$mysql_user" \
  -e MYSQL_PASSWORD="$mysql_password" \
  -e MYSQL_ALLOW_EMPTY_PASSWORD="$mysql_empty_password" \
  -e MYSQL_RANDOM_ROOT_PASSWORD="$mysql_random_password" \
  -e MYSQL_ONETIME_PASSWORD="$mysql_onetime_password" \
  --name "$name" -d mysql:8.0 > /dev/null

echo -e "Created \033[4m$name\033[0m \033[32mSuccessfully\033[0m!"
