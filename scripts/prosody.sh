#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "ports": {
        "server": 5555,
        "serf_lan": 5556
    }
}' > /tmp/consul/consul.json

consul agent -config-file=/tmp/consul/consul.json \
    -node=prosody \
    -join=$ADVERTISED_ADDRESS:3334 -retry-max=5 -retry-interval=2s \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

consul kv put "config/hostname" $FQDN
consul kv put "config/server/xmpp" $XMPP
consul kv put "config/ports/prosody/component" $PROSODY_COMPONENT_SERVICE_PORT
consul kv put "config/ports/prosody/http" $PROSODY_HTTP_SERVICE_PORT
consul kv put "config/ports/prosody/https" $PROSODY_HTTPS_SERVICE_PORT
consul kv put "config/ports/prosody/c2s" $PROSODY_C2S_SERVICE_PORT
consul kv put "config/ports/prosody/s2s" $PROSODY_S2S_SERVICE_PORT

consul-template \
    -template "/etc/prosody/templates/create_jicofo_user.sh:/etc/prosody/create_jicofo_user.sh:sh /etc/prosody/create_jicofo_user.sh" \
    -template "/etc/prosody/templates/prosody.cfg.lua:/etc/prosody/prosody.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/migrator.cfg.lua:/etc/prosody/migrator.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/config.cfg.lua:/etc/prosody/conf.d/config.cfg.lua:prosodyctl restart" &

LOG_FILE=/var/log/prosody/prosody.log
touch $LOG_FILE && chown prosody:prosody $LOG_FILE && tail -f $LOG_FILE
