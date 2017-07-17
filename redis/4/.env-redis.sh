#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
[[ ! -r '.env.sh' ]] && (echo 'Not found .env file') && exit 1
source .env.sh

# specifies the Redis external port.
port=$(sed '/^DOCKER_PORT=/!d;s/.*=//' "$env")
[[ ! "$port" ]] && read -erp "Enter the Redis host port: [6379] " port
[[ ! "$port" ]] && port=6379

export port
