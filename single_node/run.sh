#!/bin/bash

IMAGENAME=$1
HOSTNAME=$2
BRIDGENAME=$3
IPADDR=$4
CIDR=$5
HADOOPHOST=$6
SUPERVISOR=$7

echo "--- RUN.sh -----"
echo "|  IMAGENAME: $IMAGENAME"
echo "|   HOSTNAME: $HOSTNAME"
echo "| BRIDGENAME: $BRIDGENAME"
echo "|     IPADDR: $IPADDR"
echo "|       CIDR: $CIDR"
echo "| HADOOPHOST: $HADOOPHOST"
echo "| SUPERVISOR: $SUPERVISOR"
echo "----------------"

usage() {
  echo "Usage: $0 [image name] [host name] [bridge name] [ipaddr] [cidr] [hadoop host] [yes=supervisor]"
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

if [ -z $HADOOPHOST ]
then
  echo "Error: missing Hadoop Host parameter."
  usage
fi

if [ -z $SUPERVISOR ]
then
  echo "Error: missing Supervisor parameter. Must be yes or no."
  usage
fi

source /docker/setup_config_files.sh $HADOOPHOST

/docker/pipework --wait $BRIDGENAME $IMAGENAME "$IPADDR/$CIDR"

if [ "$SUPERVISOR" == "no" ]
then
  rm /etc/supervisor/conf.d/*
fi

/usr/bin/supervisord -n
