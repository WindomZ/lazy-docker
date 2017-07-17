#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2015,SC2154
[[ ! -r '.env-redis.sh' ]] && (echo 'Not found .env-redis file') && exit 1
source .env-redis.sh

# remove redis4 container
if docker ps -aq -f name="$name" --format "{{.Names}}" | grep -iq "^$name$"; then
  docker rm -f "$name" > /dev/null
fi

# run redis4 container
docker run --restart=always \
  -v "$volume/$name/data":/data \
  -v "$volume/$name/share":/share \
  -p "$port":6379 \
  --name "$name" -d redis:4 \
  redis-server --appendonly yes > /dev/null

echo -e "Created \033[4m$name\033[0m \033[32mSuccessfully\033[0m!"
