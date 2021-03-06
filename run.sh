#!/bin/bash

set -a
source project.env
if [[ $RUN_LOCALLY == true ]]; then
    ADVERTISED_ADDRESS=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
else
    ADVERTISED_ADDRESS=$(curl ipinfo.io/ip || wget http://ipinfo.io/ip -qO -)
fi
set +a

if [[ $RUN_PROSODY == true ]]; then
    docker-compose -f ./docker/compose/prosody.yml up -d --force-recreate
fi

if [[ $RUN_JITSI_MEET == true ]]; then
    docker-compose -f ./docker/compose/meet.yml up -d --force-recreate
fi

if [[ $RUN_JICOFO == true ]]; then
    docker-compose -f ./docker/compose/jicofo.yml up -d --force-recreate
fi

if [[ $RUN_JVB == true ]]; then
    docker-compose -f ./docker/compose/jvb.yml up -d --force-recreate
fi
