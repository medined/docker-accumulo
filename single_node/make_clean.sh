#!/bin/bash

IMAGENAME=$1

usage() {
  echo "Usage: $0 [image name]"
  exit 1
}

if [ -z $IMAGENAME ]
then
  echo "Error: missing image name parameter."
  usage
fi

sudo DOCKER_HOST=$DOCKER_HOST docker stop $IMAGENAME || :
sleep 2
sudo DOCKER_HOST=$DOCKER_HOST docker rm $IMAGENAME || :

