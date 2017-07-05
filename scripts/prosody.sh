#!/bin/bash

mkdir /tmp/consul

consul agent -server -bootstrap -node=focus \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

sleep 3

consul kv put "config/host" $HOST
consul kv put "component/focus/secret" secret

consul-template \
    -template "/etc/prosody/templates/prosody.cfg.lua:/etc/prosody/prosody.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/migrator.cfg.lua:/etc/prosody/migrator.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/config.cfg.lua:/etc/prosody/conf.d/config.cfg.lua:prosodyctl reload" &

touch /var/log/prosody/prosody.log && tail -f /var/log/prosody/prosody.log
