#!/bin/bash

HOSTNAME=$1

usage() {
  echo "Usage: $0 [host name]"
  exit 1
}

if [ -z $HOSTNAME ]
then
  echo "Error: missing host name parameter."
  usage
fi

# Update Supervisor configuration
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/supervisor/conf.d/accumulo.conf

# Update Hadoop configurations
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/hadoop/conf/core-site.xml
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/hadoop/conf/hdfs-site.xml
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/hadoop/conf/mapred-site.xml
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/hadoop/conf/yarn-site.xml
echo $HOSTNAME > /etc/hadoop/conf/masters
echo $HOSTNAME > /etc/hadoop/conf/slaves

# Update Accumulo configurations
sed -i "s/MYHOSTNAME/$HOSTNAME/" /etc/accumulo/conf/accumulo-site.xml
echo $HOSTNAME > /etc/accumulo/conf/gc
echo $HOSTNAME > /etc/accumulo/conf/masters
echo $HOSTNAME > /etc/accumulo/conf/monitor
echo $HOSTNAME > /etc/accumulo/conf/slaves
echo $HOSTNAME > /etc/accumulo/conf/tracers

/usr/bin/supervisord -n
