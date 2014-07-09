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

sudo docker stop $IMAGENAME || :
sleep 2
sudo docker rm $IMAGENAME || :

