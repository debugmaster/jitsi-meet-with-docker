#!/bin/bash

mkdir -p /tmp/consul

consul agent -server -bootstrap -node=focus \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

sleep 3

JICOFO_SECRET=$(echo $RANDOM | md5sum | awk '{ print $1 }')
JICOFO_AUTH_USER=focus
JICOFO_AUTH_PASSWORD=$(echo $RANDOM | md5sum | awk '{ print $1 }')

prosodyctl register $JICOFO_AUTH_USER auth.$HOST $JICOFO_AUTH_PASSWORD

consul kv put "config/host" $HOST
consul kv put "config/ports/prosody/component" $PROSODY_COMPONENT_SERVICE_PORT
consul kv put "config/ports/prosody/http" $PROSODY_HTTP_SERVICE_PORT
consul kv put "config/ports/prosody/https" $PROSODY_HTTPS_SERVICE_PORT
consul kv put "config/ports/prosody/c2s" $PROSODY_C2S_SERVICE_PORT
consul kv put "config/ports/prosody/s2s" $PROSODY_S2S_SERVICE_PORT
consul kv put "component/focus/secret" $JICOFO_SECRET
consul kv put "component/focus/auth/user" $JICOFO_AUTH_USER
consul kv put "component/focus/auth/password" $JICOFO_AUTH_PASSWORD

consul-template \
    -template "/etc/prosody/templates/prosody.cfg.lua:/etc/prosody/prosody.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/migrator.cfg.lua:/etc/prosody/migrator.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/config.cfg.lua:/etc/prosody/conf.d/config.cfg.lua:prosodyctl reload" &

touch /var/log/prosody/prosody.log && tail -f /var/log/prosody/prosody.log
