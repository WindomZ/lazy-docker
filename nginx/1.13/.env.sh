#!/usr/bin/env bash
# specifies the configuration file.
env=.env
[[ ! -f ${env} ]] && env=../.env
[[ ! -f ${env} ]] && echo -e "\033[31mNot found\033[0m the \033[4m.env\033[0m file" && exit 1

# specifies the name of docker container.
name="sed '/^DOCKER_NAME=/!d;s/.*=//' ${env}"
[[ ! ${name} ]] && read -erp "Enter the name of docker container: [nginx1.13] " name
[[ ! ${name} ]] && name="nginx1.13"

# specifies the nginx host path.
volume="sed '/^DOCKER_VOLUME=/!d;s/.*=//' ${env}"
[[ ! ${volume} ]] && read -erp "Enter the directory path for the nginx volume: [current path] " volume
[[ ! ${volume} ]] && volume=${PWD}

# specifies the nginx external host port.
port="sed '/^DOCKER_PORT=/!d;s/.*=//' ${env}"
[[ ! ${port} ]] && read -erp "Enter the nginx host port: [80] " port
[[ ! ${port} ]] && port=80

export env
export volume
export port
