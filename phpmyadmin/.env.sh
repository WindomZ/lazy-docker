#!/usr/bin/env bash
# specifies the configuration file.
env=.env
[[ ! -f "$env" ]] && env=../.env
[[ ! -f "$env" ]] && echo -e "\\033[31mNot found\\033[0m the \\033[4m.env\\033[0m file" && exit 1

# specifies the name of docker container.
name=$(sed '/^DOCKER_NAME=/!d;s/.*=//' "$env")
[[ ! "$name" ]] && read -erp "Enter the name of docker container: [phpmyadmin] " name
[[ ! "$name" ]] && name="phpmyadmin"

export env
export name
