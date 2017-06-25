#!/usr/bin/env bash
source ../.env.sh

if [ ! "$(docker ps -q -f name=${name}-db)" ]; then
  # remove mysql5.7-db container
  if [ "$(docker ps -aq -f status=exited -f name=${name}-db)" ]; then
    docker rm ${name}-db > /dev/null
  fi

  # build mysql5.7-db container
  docker run \
    -v ${volume}/mysql/data:/var/lib/mysql \
    --name ${name}-db mysql:5.7 \
    echo "Data-only container for mysql" > /dev/null
fi

echo -e "Created \033[4m${name}-db\033[0m \033[32mSuccessfully\033[0m!"
