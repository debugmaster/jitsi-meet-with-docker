#!/bin/bash

set -a
source project.env
set +a

Randomize_Port () {
    mod=$(( $2 - $1 + 1 ));
    start=$1;
    while true; do
        port=$(( ( RANDOM % $mod ) + $start ));
        nc -z $ADVERTISED_ADDRESS $port
        echo "b $mod $start $port $?" 1>&2;
        nc -z $ADVERTISED_ADDRESS $port;
        if [ $? -eq 1 ]; then
            echo $port;
            break;
        fi
    done
}

docker stop $(docker ps -q)

if [[ $RUN_BOOTSTRAP == true ]]; then
    docker-compose -f ./docker/compose/bootstrap.yml up -d
fi

if [[ $RUN_PROSODY == true ]]; then
    export RANDOM_RPC_PORT=$(Randomize_Port $RANDOM_PORT_MIN $RANDOM_PORT_MAX);
    export RANDOM_LAN_PORT=$(Randomize_Port $RANDOM_PORT_MIN $RANDOM_PORT_MAX);
    docker-compose -f ./docker/compose/prosody.yml up -d
fi
