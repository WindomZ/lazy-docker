#!/usr/bin/env bash
source .env.sh

if [ ! "$(docker ps -q -f name=mysql-backup)" ]; then
  backup_file=/backup/$(date +%Y%m%d%H%M%S).tar

  # build mysql5.7-backup container
  docker run -it --rm \
    --volumes-from mysql5.7-db \
    -v ${volume}/mysql/backup:/backup \
    --name mysql5.7-backup mysql:5.7 \
    tar cvfP ${backup_file} /var/lib/mysql

  backup_file=`echo "$volume/mysql/$backup_file" | sed "s/\/\//\//g"`

  echo -e "Dump a backup file in \033[4m$backup_file\033[0m \033[32mSuccessfully\033[0m!"
else
  echo "Dump a backup file..."
fi
