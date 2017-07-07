#!/bin/bash

mkdir -p /tmp/consul

consul agent \
    -node=jitsi-meet \
    -join=$ADVERTISED_ADDRESS:3333 -retry-max=5 -retry-interval=2s \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

consul-template \
    -template "/etc/jitsi/meet/templates/config.conf:/etc/nginx/sites-enabled/config.conf:service nginx restart" \
    -template "/etc/jitsi/meet/templates/config.js:/etc/jitsi/meet/config.js" &
LOG_FILE=/var/log/nginx/access.log
touch $LOG_FILE && chown meet:jitsi $LOG_FILE && tail -f $LOG_FILE
