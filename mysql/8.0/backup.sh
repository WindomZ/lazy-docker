#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '.env.sh' ]] && (echo 'Not found .env file') && exit 1
source .env.sh

if ! docker ps -q -f name="$name-backup" --format "{{.Names}}" | grep -iq "^$name-backup$"; then
  backup_file="/backup/$name-$(date +%Y%m%d%H%M%S).tar"

  # run mysql8.0-backup container
  docker run -it --rm \
    --volumes-from "$name-db" \
    -v "$volume/$name/backup":/backup \
    --name "$name-backup" mysql:8.0 \
    tar cvfP "$backup_file" /var/lib/mysql

  backup_file=$(echo "$volume/$name/$backup_file" | sed "s/\/\//\//g")

  echo -e "Dump a backup file in \033[4m$backup_file\033[0m \033[32mSuccessfully\033[0m!"
else
  echo "Dump a backup file..."
fi
