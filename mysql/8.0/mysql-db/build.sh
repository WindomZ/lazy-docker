#!/usr/bin/env bash
# specifies the configuration file.
env=../.env
[[ ! -f "$env" ]] && echo -e "\033[31mNot found\033[0m the \033[4m.env\033[0m file" && exit 1

# specifies the name of docker container.
name=$(sed '/^DOCKER_NAME=/!d;s/.*=//' "$env")
[[ ! "$name" ]] && read -erp "Enter the name of docker container: [mysql8.0] " name
[[ ! "$name" ]] && name="mysql8.0"

# specifies the MYSQL data storage path.
volume=$(sed '/^DOCKER_VOLUME=/!d;s/.*=//' "$env")
[[ ! "$volume" ]] && read -erp "Enter the directory path for the MYSQL volume: [current path] " volume
[[ ! "$volume" ]] && volume=$PWD

if ! docker ps -q -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
  # remove mysql8.0-db container
  if docker ps -aq -f status=exited -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
    docker rm ${name}-db > /dev/null
  fi

  # run mysql8.0-db container
  docker run \
    -v "$volume/$name/data":/var/lib/mysql \
    --name "$name-db" mysql:8.0 \
    echo "Data-only container for mysql" > /dev/null

  echo -e "Created \033[4m$name-db\033[0m \033[32mSuccessfully\033[0m!"
fi
