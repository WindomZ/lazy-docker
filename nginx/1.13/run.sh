#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2015,SC2154
[[ ! -r '.env.sh' ]] && (echo 'Not found .env file') && exit 1
source .env.sh

# whether or not to import nginx.conf
if [[ -s 'nginx.conf' ]]; then
  while true; do
    read -erp "Do you use nginx.conf?: [Y/n] " yn
    case ${yn} in
      [Yy]*|'' ) volume_nginx_conf=true; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes, y, no, or n.";;
    esac
  done
fi
#[[ ${volume_nginx_conf} ]] && echo "YES" || echo "NO"

for file in ./conf.d/*; do
  if [[ -f ${file} ]]; then
    volume_nginx_conf_d=true
    break
  fi
done
if [[ ${volume_nginx_conf_d} ]]; then
  while true; do
    read -erp "Do you overwrite nginx/conf.d?: [Y/n] " yn
    case ${yn} in
      [Yy]*|'' ) break;;
      [Nn]* ) unset volume_nginx_conf_d; break;;
      * ) echo "Please answer yes, y, no, or n.";;
    esac
  done
fi
#[[ ${volume_nginx_conf_d} ]] && echo "YES" || echo "NO"

# remove nginx container
if docker ps -aq -f name="$name" --format "{{.Names}}" | grep -iq "^${name}$"; then
  docker rm -f "$name" > /dev/null
fi

[[ ${volume_nginx_conf} ]] \
  && volume_nginx_conf="-v $PWD/nginx.conf:/etc/nginx/nginx.conf:ro" \
  || unset volume_nginx_conf

[[ ${volume_nginx_conf_d} ]] \
  && volume_nginx_conf_d="-v $PWD/conf.d/:/etc/nginx/conf.d/" \
  || unset volume_nginx_conf_d

# build & run nginx container

if output=$(docker run --restart=always \
  -p "$port":80 \
  -v "$volume/$name/html":/usr/share/nginx/html:ro \
  -v "$volume/$name/logs":/var/log/nginx \
  -v "$volume/$name"/share:/share \
  "$volume_nginx_conf" \
  "$volume_nginx_conf_d" \
  --name "$name" -d nginx:1.13 > /dev/null); then
  [[ ! -r "$volume/$name"/html || ! -w "$volume/$name"/html ]] && sudo chmod -R a+rw "$volume/$name"/html
else
  echo -e "Created \033[4m$name\033[0m \033[31mFailed\033[0m: $output" && exit 1
fi

echo -e "Created \033[4m$name\033[0m \033[32mSuccessfully\033[0m!"
