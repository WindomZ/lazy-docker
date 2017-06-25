#!/usr/bin/env bash
source .env.sh

[[ ! $1 ]] && echo -e "\033[31mMissing backup file path arguments!\033[0m" && exit 1

restore_file=`echo "${volume}/mysql/backup/$1" | sed "s/\/\//\//g"`
[[ ! -f ${restore_file} ]] && echo -e "\033[31mNot found\033[0m the \033[4m${restore_file}\033[0m file" && exit 1

if [ ! "$(docker ps -q -f name=mysql-restore)" ]; then
  # build mysql5.7-restore container
  docker run -it --rm \
    --volumes-from mysql5.7-db \
    -v ${volume}/mysql/backup:/backup \
    --name mysql5.7-restore mysql:5.7 \
    tar xvfP "/backup/$1" /var/lib/mysql

  echo -e "Restore the backup file in \033[4m$restore_file\033[0m \033[32mSuccessfully\033[0m!"
else
  echo "Restore a backup file..."
fi