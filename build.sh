#!/bin/bash

source project.env

docker build \
    --build-arg RELEASE=$PROSODY_RELEASE \
    --build-arg REPOSITORY=$PROSODY_REPOSITORY \
    -t prosody ./docker/prosody/
