#!/bin/bash

HOSTNAME=$1
IMAGENAME=$2
DOCKERPORT=$3

usage() {
  echo "Usage: $0 [host name] [image name] [docker port]"
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

DOCKEROPTS="$DOCKEROPTS"

if [ ! -z $DOCKERPORT ]
then
  DOCKEROPTS="-H :$DOCKERPORT"
fi

sudo docker $DOCKEROPTS run -d --name=$IMAGENAME -h=$HOSTNAME -P medined/accumulo /run.sh $HOSTNAME

