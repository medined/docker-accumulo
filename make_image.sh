#!/bin/bash

DOCKERPORT=$3

usage() {
  echo "Usage: $0 [docker port]"
  exit 1
}

DOCKEROPTS="$DOCKEROPTS"

if [ ! -z $DOCKERPORT ]
then
  DOCKEROPTS="-H :$DOCKERPORT"
fi

sudo docker $DOCKEROPTS run -v /usr/local/bin:/target jpetazzo/nsenter
sudo docker $DOCKEROPTS build -rm -t='medined/accumulo' .
sudo docker $DOCKEROPTS run -d --name=accbuild -h=MYHOSTNAME -p=127.0.0.10:2244:22 medined/accumulo /usr/bin/supervisord -n
sleep 5
ssh -i dotssh/accumulo -p 2244 root@127.0.0.10 /docker/init_accumulo.sh
sudo docker $DOCKEROPTS commit --author="David Medinets <david.medinets@gmail.com>" accbuild medined/accumulo
sudo docker $DOCKEROPTS stop accbuild || :
sleep 2
sudo docker $DOCKEROPTS rm accbuild || :
