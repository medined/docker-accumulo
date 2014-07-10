#!/bin/bash

HOSTNAME=$1
IMAGENAME=$2

usage() {
  echo "Usage: $0 [host name] [image name]"
  exit 1
}

if [ -z $HOSTNAME ]
then
  echo "Error: missing host name parameter."
  usage
fi

if [ -z $IMAGENAME ]
then
  echo "Error: missing image name parameter."
  usage
fi

sudo DOCKER_HOST=$DOCKER_HOST docker run -d --name=$IMAGENAME -h=$HOSTNAME -P medined/accumulo /run.sh $HOSTNAME
