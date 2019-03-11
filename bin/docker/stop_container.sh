#!/bin/bash -e

echo "--> Killing old containers ..."
# docker kill $(docker ps -q --filter ancestor=dz_dev) 2> /dev/null || true
docker kill $(docker container ls | grep 8023 | cut -d' ' -f1) || true
