#!/bin/bash

mkdir -p /tmp/consul

echo -e '{
    "ports": {
        "server": 6667,
        "serf_lan": 6666
    }
}' > /tmp/consul/consul.json

consul agent -config-file=/tmp/consul/consul.json \
    -node=jvb-$HOSTNAME \
    -join=$ADVERTISED_ADDRESS:3333 -retry-max=5 -retry-interval=2s \
    -bind=$(getent hosts $HOSTNAME | awk '{ print $1 }') \
    -advertise=$ADVERTISED_ADDRESS \
    -data-dir=/tmp/consul \
    > /tmp/consul/consul.log \
    2> /tmp/consul/consul.err &

# Wait some time for Consul to set up
sleep 10

consul info > /dev/null || (echo "Consul failed to start" && exit 1);

JVB_SECRET=$(echo $RANDOM | md5sum | awk '{ print $1 }')

consul kv put "component/videobridges/$HOSTNAME" $JVB_SECRET

consul-template \
    -template "/etc/jitsi/videobridge/templates/config:/etc/jitsi/videobridge/config:service jitsi-videobridge restart" \
    -template "/etc/jitsi/videobridge/templates/sip-communicator.properties:/etc/jitsi/videobridge/sip-communicator.properties:service jitsi-videobridge restart" \
    -template "/etc/jitsi/videobridge/templates/logging.properties:/etc/jitsi/videobridge/logging.properties:service jitsi-videobridge restart" &

LOG_FILE=/var/log/jitsi/jvb.log
touch $LOG_FILE && chown jvb:jitsi $LOG_FILE && tail -f $LOG_FILE
