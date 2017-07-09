#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "ports": {
        "server": 5554,
        "serf_lan": 5555
    }
}' > /tmp/consul/consul.json

if [[ $(getent hosts $XMPP_SERVER | awk '{ print $1 }') != $ADVERTISED_ADDRESS ]]; then
    echo "Prosody may not work because $XMPP_SERVER was not resolved $ADVERTISED_ADDRESS."
fi

consul agent -server -bootstrap -config-file=/tmp/consul/consul.json \
    -node=prosody \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

consul kv put "config/hostname" $DOMAIN
consul kv put "config/server/xmpp" $XMPP_SERVER
consul kv put "config/ports/prosody/component" $PROSODY_COMPONENT_SERVICE_PORT
consul kv put "config/ports/prosody/http" $PROSODY_HTTP_SERVICE_PORT
consul kv put "config/ports/prosody/https" $PROSODY_HTTPS_SERVICE_PORT
consul kv put "config/ports/prosody/c2s" $PROSODY_C2S_SERVICE_PORT
consul kv put "config/ports/prosody/s2s" $PROSODY_S2S_SERVICE_PORT

consul-template \
    -template "/etc/prosody/templates/create_jicofo_user.sh:/etc/prosody/create_jicofo_user.sh:sh /etc/prosody/create_jicofo_user.sh" \
    -template "/etc/prosody/templates/prosody.cfg.lua:/etc/prosody/prosody.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/migrator.cfg.lua:/etc/prosody/migrator.cfg.lua:prosodyctl restart" \
    -template "/etc/prosody/templates/config.cfg.lua:/etc/prosody/conf.d/config.cfg.lua:prosodyctl reload" &

LOG_FILE=/var/log/prosody/prosody.log
touch $LOG_FILE && chown prosody:prosody $LOG_FILE && tail -f $LOG_FILE
