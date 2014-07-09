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


ACCUMULO_PID=$(docker inspect --format {{.State.Pid}} $IMAGENAME)
sudo nsenter --target $ACCUMULO_PID --mount --uts --ipc --net --pid

