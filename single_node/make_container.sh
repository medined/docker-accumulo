#!/bin/bash

HOSTNAME=$1
IMAGENAME=$2
BRIDGENAME=$3
SUBNET=$4

usage() {
  echo "Usage: $0 [host name] [image name] [bridge name] [class c subnet]"
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

if [ -z $BRIDGENAME ]
then
  echo "Error: missing bridge name parameter."
  usage
fi

if [ -z $SUBNET ]
then
  echo "Error: missing Class C subnet parameter. For example 10.0.10"
  usage
fi

IPADDR="${SUBNET}.1"
CIDR=24

sudo DOCKER_HOST=$DOCKER_HOST docker run -d --name=$IMAGENAME -h=$HOSTNAME -P medined/accumulo /docker/run.sh $IMAGENAME $HOSTNAME $BRIDGENAME $IPADDR $CIDR

sudo DOCKER_HOST=$DOCKER_HOST ./pipework $BRIDGENAME $IMAGENAME "$IPADDR/$CIDR"
sudo ifconfig $BRIDGENAME "${SUBNET}.254"
