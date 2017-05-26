#!/bin/bash

source project.env

docker build \
    -t ubuntu:updated \
    -f ./docker/util/Dockerfile-ubuntu ./docker/util/

docker build \
    --build-arg RELEASE=$PROSODY_RELEASE \
    --build-arg REPOSITORY=$PROSODY_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_PROSODY \
    -t $DOCKER_REPOSITORY/prosody \
    -f ./docker/prosody/Dockerfile-prosody ./docker/prosody/
