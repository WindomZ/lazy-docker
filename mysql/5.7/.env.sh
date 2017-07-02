#!/usr/bin/env bash
# specifies the configuration file.
env=.env
[[ ! -f "$env" ]] && env=../.env
[[ ! -f "$env" ]] && echo -e "\033[31mNot found\033[0m the \033[4m.env\033[0m file" && exit 1

# specifies the name of docker container.
name=$(sed '/^DOCKER_NAME=/!d;s/.*=//' "$env")
[[ ! "$name" ]] && read -erp "Enter the name of docker container: [mysql5.7] " name
[[ ! "$name" ]] && name="mysql5.7"

# specifies the MYSQL data storage path.
volume=$(sed '/^DOCKER_VOLUME=/!d;s/.*=//' "$env")
[[ ! "$volume" ]] && read -erp "Enter the directory path for the MYSQL volume: [current path] " volume
[[ ! "$volume" ]] && volume=${PWD}

# specifies the MYSQL external port.
port=$(sed '/^DOCKER_PORT=/!d;s/.*=//' "$env")
[[ ! "$port" ]] && read -erp "Enter the MYSQL host port: [3306] " port
[[ ! "$port" ]] && port=3306

# specifies the password that will be set for the MySQL root superuser account.
root_password=$(sed '/^MYSQL_ROOT_PASSWORD=/!d;s/.*=//' "$env")
[[ ! "$root_password" ]] && read -erp "Enter the MySQL root password: " root_password

# specifies other environment Variables.
mysql_database=$(sed '/^MYSQL_DATABASE=/!d;s/.*=//' "$env")
mysql_user=$(sed '/^MYSQL_USER=/!d;s/.*=//' "$env")
mysql_password=$(sed '/^MYSQL_PASSWORD=/!d;s/.*=//' "$env")
mysql_empty_password=$(sed '/^MYSQL_ALLOW_EMPTY_PASSWORD=/!d;s/.*=//' "$env")
mysql_random_password=$(sed '/^MYSQL_RANDOM_ROOT_PASSWORD=/!d;s/.*=//' "$env")
mysql_onetime_password=$(sed '/^MYSQL_ONETIME_PASSWORD=/!d;s/.*=//' "$env")
[[ ! "$root_password" ]] && mysql_empty_password=yes && unset mysql_random_password

export env
export volume
export port
export root_password
export mysql_database
export mysql_user
export mysql_password
export mysql_empty_password
export mysql_random_password
export mysql_onetime_password
