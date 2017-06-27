#!/usr/bin/env bash
source .env.sh

# whether or not to import nginx.conf
if [[ -s 'nginx.conf' ]]; then
  while true; do
    read -e -p "Do you use nginx.conf?: [Y/n] " yn
    case ${yn} in
      [Yy]*|'' ) volume_nginx_conf=true; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
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
    read -e -p "Do you overwrite nginx/conf.d?: [Y/n] " yn
    case ${yn} in
      [Yy]*|'' ) break;;
      [Nn]* ) unset volume_nginx_conf_d; break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
fi
#[[ ${volume_nginx_conf_d} ]] && echo "YES" || echo "NO"

# remove nginx container
if [ "$(echo "$(docker ps -aq -f name=${name} --format "{{.Names}}")" | grep -i "^${name}$")" ]; then
  docker rm -f ${name} > /dev/null
fi

[[ ${volume_nginx_conf} ]] \
  && volume_nginx_conf="-v ${PWD}/nginx.conf:/etc/nginx/nginx.conf:ro" \
  || unset volume_nginx_conf

[[ ${volume_nginx_conf_d} ]] \
  && volume_nginx_conf_d="-v ${PWD}/conf.d/:/etc/nginx/conf.d/" \
  || unset volume_nginx_conf_d

# build & run nginx container
docker run --restart=always \
  -p ${port}:80 \
  -v ${volume}/${name}/html:/usr/share/nginx/html:ro \
  -v ${volume}/${name}/logs:/var/log/nginx \
  -v ${volume}/${name}/share:/share \
  ${volume_nginx_conf} \
  ${volume_nginx_conf_d} \
  --name ${name} -d nginx:1.13 > /dev/null

if [ $? -ne 0 ]; then
  exit 0
elif [ ! -r ${volume}/${name}/html -o ! -w ${volume}/${name}/html ]; then
  sudo chmod -R a+rw ${volume}/${name}/html
fi
