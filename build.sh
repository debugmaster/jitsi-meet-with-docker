#!/bin/bash

source project.env

if [[ $BUILD_PROSODY_IMAGE == true ]]; then
    if [[ $BUILD_PROSODY_FROM_SCRATCH == true ]]; then
        docker build \
        --build-arg RELEASE=$PROSODY_RELEASE \
        --build-arg REPOSITORY=$PROSODY_REPOSITORY \
        -t $DOCKER_REPOSITORY/prosody \
        -f ./docker/scratch/Dockerfile-prosody .
    else
        docker build \
        -t $DOCKER_REPOSITORY/prosody \
        -f ./docker/apt/Dockerfile-prosody .
    fi
fi

if [[ $BUILD_JITSI_MEET_IMAGE == true ]]; then
    if [[ $BUILD_JITSI_MEET_FROM_SCRATCH == true ]]; then
        docker build \
        --build-arg RELEASE=$JITSI_MEET_RELEASE \
        --build-arg RELEASE_VERSION=$JITSI_MEET_RELEASE_VERSION \
        --build-arg REPOSITORY=$JITSI_MEET_REPOSITORY \
        -t $DOCKER_REPOSITORY/jitsi-meet \
        -f ./docker/scratch/Dockerfile-jitsi-meet .
    else
        docker build \
        -t $DOCKER_REPOSITORY/jitsi-meet \
        -f ./docker/apt/Dockerfile-jitsi-meet .
    fi
fi

if [[ $BUILD_JICOFO_IMAGE == true ]]; then
    if [[ $BUILD_JICOFO_FROM_SCRATCH == true ]]; then
        docker build \
        --build-arg RELEASE=$JICOFO_RELEASE \
        --build-arg RELEASE_VERSION=$JICOFO_RELEASE_VERSION \
        --build-arg REPOSITORY=$JICOFO_REPOSITORY \
        -t $DOCKER_REPOSITORY/jicofo \
        -f ./docker/scratch/Dockerfile-jicofo .
    else
        docker build \
        -t $DOCKER_REPOSITORY/jicofo \
        -f ./docker/apt/Dockerfile-jicofo .
    fi
fi

if [[ $BUILD_JVB_IMAGE == true ]]; then
    if [[ $BUILD_JVB_FROM_SCRATCH == true ]]; then
        docker build \
        --build-arg RELEASE=$JVB_RELEASE \
        --build-arg RELEASE_VERSION=$JVB_RELEASE_VERSION \
        --build-arg REPOSITORY=$JVB_REPOSITORY \
        -t $DOCKER_REPOSITORY/jitsi-videobridge \
        -f ./docker/scratch/Dockerfile-jitsi-videobridge .
    else
        docker build \
        -t $DOCKER_REPOSITORY/jitsi-videobridge \
        -f ./docker/apt/Dockerfile-jitsi-videobridge .
    fi
fi
