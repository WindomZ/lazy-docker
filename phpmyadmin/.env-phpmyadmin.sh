#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '.env.sh' ]] && (echo 'Not found .env file') && exit 1
source .env.sh

# specifies the phpMyAdmin external port.
port=$(sed '/^DOCKER_PORT=/!d;s/.*=//' "$env")
[[ ! "$port" ]] && read -erp "Enter the phpMyAdmin host port: [8080] " port
[[ ! "$port" ]] && port=8080

# specifies the name of running mysql instance container.
mysql_name=$(sed '/^LINK_MYSQL_NAME=/!d;s/.*=//' "$env")
[[ ! "$mysql_name" ]] && read -erp "Enter the MySQL container name: " mysql_name

export port
export mysql_name
