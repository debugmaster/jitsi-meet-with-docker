#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "advertise_addrs": {
        "rpc": "'$ADVERTISED_ADDRESS':'$RANDOM_RPC_PORT'",
        "serf_lan": "'$ADVERTISED_ADDRESS':'$RANDOM_LAN_PORT'"
    }
}' > /tmp/consul/consul.json

consul agent -config-file=/tmp/consul/consul.json \
    -node=jicofo \
    -join=$ADVERTISED_ADDRESS:$LAN_PORT -retry-max=5 -retry-interval=2s \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

consul-template \
    -template "/etc/jitsi/jicofo/templates/config:/etc/jitsi/jicofo/config:service jicofo restart" \
    -template "/etc/jitsi/jicofo/templates/sip-communicator.properties:/etc/jitsi/jicofo/sip-communicator.properties:service jicofo restart" \
    -template "/etc/jitsi/jicofo/templates/logging.properties:/etc/jitsi/jicofo/logging.properties:service jicofo restart" &

touch /var/log/jitsi/jicofo.log && tail -f /var/log/jitsi/jicofo.log
