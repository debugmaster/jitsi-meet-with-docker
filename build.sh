#!/bin/bash

source project.env

docker build \
    --build-arg RELEASE=$PROSODY_RELEASE \
    --build-arg REPOSITORY=$PROSODY_REPOSITORY \
    --build-arg SHOULD_BUILD=$BUILD_PROSODY \
    -t prosody ./docker/prosody/
