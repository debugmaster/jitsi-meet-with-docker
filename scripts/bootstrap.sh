#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "ports": {
        "server": 3334,
        "serf_lan": 3333
    }
}' > /etc/consul/consul.json

consul agent -server -bootstrap -config-file=/etc/consul/consul.json \
    -node=bootstrap \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul
