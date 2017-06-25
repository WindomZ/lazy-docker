#!/usr/bin/env bash
# specifies the configuration file.
env=.env
[[ ! -f ${env} ]] && env=../.env
[[ ! -f ${env} ]] && echo -e "\033[31mNot found\033[0m the \033[4m.env\033[0m file" && exit 1

# specifies the MYSQL data storage path.
volume=`sed '/^DOCKER_VOLUME=/!d;s/.*=//' ${env}`
[[ ! ${volume} ]] && read -e -p "Enter the directory path for the volume: (default current) " volume
[[ ! ${volume} ]] && volume=${PWD}

export env
export volume
