#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "ports": {
        "server": 6666,
        "serf_lan": 6667
    }
}' > /tmp/consul/consul.json

consul agent -config-file=/tmp/consul/consul.json \
    -node=jicofo \
    -join=$ADVERTISED_ADDRESS:3334 -retry-max=5 -retry-interval=2s \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

JICOFO_SECRET=$(echo $RANDOM | md5sum | awk '{ print $1 }')
JICOFO_AUTH_USER=focus
JICOFO_AUTH_PASSWORD=$(echo $RANDOM | md5sum | awk '{ print $1 }')

consul kv put "component/focus/secret" $JICOFO_SECRET
consul kv put "component/focus/auth/user" $JICOFO_AUTH_USER
consul kv put "component/focus/auth/password" $JICOFO_AUTH_PASSWORD

consul-template \
    -template "/etc/jitsi/jicofo/templates/config:/etc/jitsi/jicofo/config:service jicofo restart" \
    -template "/etc/jitsi/jicofo/templates/sip-communicator.properties:/etc/jitsi/jicofo/sip-communicator.properties:service jicofo restart" \
    -template "/etc/jitsi/jicofo/templates/logging.properties:/etc/jitsi/jicofo/logging.properties:service jicofo restart" &

LOG_FILE=/var/log/jitsi/jicofo.log
touch $LOG_FILE && chown jicofo:jitsi $LOG_FILE && tail -f $LOG_FILE
