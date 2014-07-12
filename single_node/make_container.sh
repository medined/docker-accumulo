#!/bin/bash

HOSTNAME=$1
IMAGENAME=$2
BRIDGENAME=$3
SUBNET=$4
NODEID=$5
HADOOPHOST=$6
SUPERVISOR=$7

usage() {
  echo "Usage: $0 [host name] [image name] [bridge name] [class c subnet] [hadoop host] [yes=supervisor]"
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

if [ -z $NODEID ]
then
  echo "Error: missing Node ID parameter. Should be number from 1 to 253."
  usage
fi

if [ -z $HADOOPHOST ]
then
  echo "Error: missing Hadoop Host parameter. Should be IP Address."
  usage
fi

if [ -z $SUPERVISOR ]
then
  echo "Error: missing Supervisor parameter. Must be yes or no."
  usage
fi

IPADDR="${SUBNET}.${NODEID}"
CIDR=24

sudo DOCKER_HOST=$DOCKER_HOST docker run -d --name=$IMAGENAME -h=$HOSTNAME -P medined/accumulo /docker/run.sh $IMAGENAME $HOSTNAME $BRIDGENAME $IPADDR $CIDR $HADOOPHOST $SUPERVISOR

sudo DOCKER_HOST=$DOCKER_HOST ./pipework $BRIDGENAME $IMAGENAME "$IPADDR/$CIDR"

#####
# Create bridge if needed.
##
BRIDGEP=$(brctl show $BRIDGENAME | grep "No such device")
if [ $BRIDGEP ]
then
  echo "Creating Bridge $BRIDGENAME"
  sudo ifconfig $BRIDGENAME "${SUBNET}.254"
else
  echo "Using bridge $BRIDGENAME"
fi

