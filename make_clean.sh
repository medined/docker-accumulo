#!/bin/bash

IMAGENAME=$1
DOCKERPORT=$2

usage() {
  echo "Usage: $0 [image name] [docker port]"
  exit 1
}

if [ -z $IMAGENAME ]
then
  echo "Error: missing image name parameter."
  usage
fi

DOCKEROPTS="$DOCKEROPTS"

if [ ! -z $DOCKERPORT ]
then
  DOCKEROPTS="-H :$DOCKERPORT"
fi

sudo docker $DOCKEROPTS stop $IMAGENAME || :
sleep 2
sudo docker $DOCKEROPTS rm $IMAGENAME || :

