#!/bin/bash

set -a
source project.env
if [[ $RUN_LOCALLY == true ]]; then
    ADVERTISED_ADDRESS=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
else
    ADVERTISED_ADDRESS=$(curl ipinfo.io/ip || wget http://ipinfo.io/ip -qO -)
fi
set +a

docker stop $(docker ps -q)

if [[ $RUN_BOOTSTRAP == true ]]; then
    docker-compose -f ./docker/compose/bootstrap.yml up -d
fi

if [[ $RUN_PROSODY == true ]]; then
    docker-compose -f ./docker/compose/prosody.yml up -d
fi

if [[ $RUN_JICOFO == true ]]; then
    docker-compose -f ./docker/compose/jicofo.yml up -d
fi
