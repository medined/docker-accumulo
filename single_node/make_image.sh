#!/bin/bash

hash nsenter 2>/dev/null || { echo >&2 "Installing nsenter"; sudo DOCKER_HOST=$DOCKER_HOST docker run -v /usr/local/bin:/target jpetazzo/nsenter;  }
sudo DOCKER_HOST=$DOCKER_HOST docker build --rm=true -t='uninitialized_accumulo' .

####
# Hadoop needs to be running in order to initialize Accumulo. Therefore we need to 
# spinup an uninitialized container. It has zookeeper and hadoop running.
#
# The hostname is specified so that we can use pre-created hadoop configuration files. 
####
sudo DOCKER_HOST=$DOCKER_HOST docker run -d --name=accbuild -h=MYHOSTNAME -p=127.0.0.10:2244:22 uninitialized_accumulo /usr/bin/supervisord -n
sleep 5

ACCUMULO_PID=$(DOCKER_HOST=$DOCKER_HOST docker inspect --format {{.State.Pid}} accbuild)
sudo nsenter --target $ACCUMULO_PID --mount --uts --ipc --net --pid /docker/init_accumulo.sh

#ssh -i dotssh/accumulo -p 2244 root@127.0.0.10 /docker/init_accumulo.sh
IGNORE=$(sudo DOCKER_HOST=$DOCKER_HOST docker commit --author="David Medinets <david.medinets@gmail.com>" accbuild accumulo)
IGNORE=$(sudo DOCKER_HOST=$DOCKER_HOST docker stop accbuild || :)
IGNORE=$(sudo DOCKER_HOST=$DOCKER_HOST docker rm accbuild || :)
