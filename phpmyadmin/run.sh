#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '.env-phpmyadmin.sh' ]] && (echo 'Not found .env-phpmyadmin file') && exit 1
source .env-phpmyadmin.sh

# remove phpmyadmin container
if docker ps -aq -f name="$name" --format "{{.Names}}" | grep -iq "^$name$"; then
  docker rm -f "$name" > /dev/null
fi

# run phpmyadmin container
docker run --restart=always \
  -p "$port":80 \
  --name "$name" --link "$mysql_name":db \
  -d phpmyadmin/phpmyadmin > /dev/null

echo -e "Created \\033[4m$name\\033[0m \\033[32mSuccessfully\\033[0m!"
