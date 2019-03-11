#!/bin/bash -e

IMG_NAME='dz_dev'
SSH_KEY=`cat ~/.ssh/id_rsa.pub`

cd ~/bin/docker/
docker build -t "$IMG_NAME" --build-arg SSH_KEY="$SSH_KEY" .
echo "Done building docker image $IMG_NAME"
