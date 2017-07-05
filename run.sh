#!/bin/bash

set -a
source project.env
set +a

if [[ $RUN_PROSODY == true ]]; then
    docker stack deploy -c ./docker/compose/prosody.yml prosody
fi
