#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '../.env.sh' ]] && (echo 'Not found .env file') && exit 1
source ../.env.sh

if ! docker ps -q -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
  # remove mysql8.0-db container
  if docker ps -aq -f status=exited -f name="$name-db" --format "{{.Names}}" | grep -iq "^$name-db$"; then
    docker rm "$name-db" > /dev/null
  fi

  # run mysql8.0-db container
  docker run \
    -v "$volume/$name/data":/var/lib/mysql \
    --name "$name-db" mysql:8.0 \
    echo "Data-only container for mysql" > /dev/null

  echo -e "Created \033[4m$name-db\033[0m \033[32mSuccessfully\033[0m!"
fi
