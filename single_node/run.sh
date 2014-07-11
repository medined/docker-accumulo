#!/bin/bash

IMAGENAME=$1
HOSTNAME=$2
BRIDGENAME=$3
IPADDR=$4
CIDR=$5

echo "--- RUN.sh -----"
echo "|  IMAGENAME: $IMAGENAME"
echo "|   HOSTNAME: $HOSTNAME"
echo "| BRIDGENAME: $BRIDGENAME"
echo "|     IPADDR: $IPADDR"
echo "|       CIDR: $CIDR"
echo "----------------"

usage() {
  echo "Usage: $0 [image name] [host name] [bridge name] [ipaddr] [cidr]"
  exit 1
}

if [ -z $IMAGENAME ]
then
  echo "Error: missing image name parameter."
  usage
fi

if [ -z $HOSTNAME ]
then
  echo "Error: missing host name parameter."
  usage
fi

if [ -z $BRIDGENAME ]
then
  echo "Error: missing bridge name parameter."
  usage
fi

if [ -z $IPADDR ]
then
  echo "Error: missing IP Address parameter."
  usage
fi

if [ -z $CIDR ]
then
  echo "Error: missing CIDR parameter. Typically 24."
  usage
fi

source /docker/setup_config_files.sh $HOSTNAME

/docker/pipework --wait $BRIDGENAME $IMAGENAME "$IPADDR/$CIDR"

/usr/bin/supervisord -n
