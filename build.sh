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

docker build \
    --build-arg RELEASE=$JICOFO_RELEASE \
    --build-arg RELEASE_VERSION=$JICOFO_RELEASE_VERSION \
    --build-arg REPOSITORY=$JICOFO_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_JICOFO \
    -t $DOCKER_REPOSITORY/jicofo \
    -f ./docker/jitsi/Dockerfile-jicofo ./docker/jitsi/
