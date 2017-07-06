#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "advertise_addrs": {
        "rpc": "'$ADVERTISED_ADDRESS':'$RPC_PORT'",
        "serf_lan": "'$ADVERTISED_ADDRESS':'$LAN_PORT'"
    }
}' > /etc/consul/consul.json

consul agent -server -bootstrap -config-file=/etc/consul/consul.json \
    -node=bootstrap \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -data-dir=/tmp/consul
