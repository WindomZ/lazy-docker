#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '.env.sh' ]] && (echo 'Not found .env file') && exit 1
source .env.sh

[[ ! $1 ]] && echo -e "\033[31mMissing backup file name arguments!\033[0m" && exit 1

restore_file=$(echo "$volume/$name/backup/$1" | sed "s/\/\//\//g")
[[ ! -f "$restore_file" ]] && echo -e "\033[31mNot found\033[0m the \033[4m${restore_file}\033[0m file" && exit 1

if ! docker ps -q -f name="$name-restore" --format "{{.Names}}" | grep -iq "^$name-restore$"; then
  # run mysql8.0-restore container
  docker run -it --rm \
    --volumes-from "$name-db" \
    -v "$volume/$name/backup":/backup \
    --name "$name-restore" mysql:8.0 \
    tar xvfP "/backup/$1" /var/lib/mysql

  echo -e "Restore the backup file in \033[4m$restore_file\033[0m \033[32mSuccessfully\033[0m!"
else
  echo "Restore a backup file..."
fi
