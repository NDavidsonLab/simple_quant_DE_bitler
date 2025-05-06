#!/usr/bin/env bash

IMAGE_NAME="training-txome-prep:latest"

docker build -t ${IMAGE_NAME} . && \
docker run --rm -it -v $PWD:/app -w /app ${IMAGE_NAME} /bin/bash