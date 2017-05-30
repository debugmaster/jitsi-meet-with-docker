#!/bin/bash

source project.env

docker build \
    -t ubuntu:updated \
    -f ./docker/Dockerfile-ubuntu ./docker/

docker build \
    --build-arg RELEASE=$PROSODY_RELEASE \
    --build-arg REPOSITORY=$PROSODY_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_PROSODY \
    -t $DOCKER_REPOSITORY/prosody \
    -f ./docker/Dockerfile-prosody ./docker/

docker build \
    --build-arg RELEASE=$JITSI_MEET_RELEASE \
    --build-arg REPOSITORY=$JITSI_MEET_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_JITSI_MEET \
    -t $DOCKER_REPOSITORY/jitsi-meet \
    -f ./docker/Dockerfile-jitsi-meet ./docker/

docker build \
    --build-arg RELEASE=$JICOFO_RELEASE \
    --build-arg RELEASE_VERSION=$JICOFO_RELEASE_VERSION \
    --build-arg REPOSITORY=$JICOFO_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_JICOFO \
    -t $DOCKER_REPOSITORY/jicofo \
    -f ./docker/Dockerfile-jicofo ./docker/

docker build \
    --build-arg RELEASE=$JVB_RELEASE \
    --build-arg RELEASE_VERSION=$JVB_RELEASE_VERSION \
    --build-arg REPOSITORY=$JVB_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_JVB \
    -t $DOCKER_REPOSITORY/jitsi-videobridge \
    -f ./docker/Dockerfile-jitsi-videobridge ./docker/
