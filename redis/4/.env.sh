#!/usr/bin/env bash
# specifies the configuration file.
env=.env
[[ ! -f "$env" ]] && env=../.env
[[ ! -f "$env" ]] && echo -e "\033[31mNot found\033[0m the \033[4m.env\033[0m file" && exit 1

# specifies the name of docker container.
name=$(sed '/^DOCKER_NAME=/!d;s/.*=//' "$env")
[[ ! "$name" ]] && read -erp "Enter the name of docker container: [redis4] " name
[[ ! "$name" ]] && name="redis4"

# specifies the Redis data storage path.
volume=$(sed '/^DOCKER_VOLUME=/!d;s/.*=//' "$env")
[[ ! "$volume" ]] && read -erp "Enter the directory path for the Redis volume: [current path] " volume
[[ ! "$volume" ]] && volume=$PWD

export env
export name
export volume
