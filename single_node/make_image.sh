#!/bin/bash

hash nsenter 2>/dev/null || { echo >&2 "Installing nsenter"; sudo DOCKER_HOST=$DOCKER_HOST docker run -v /usr/local/bin:/target jpetazzo/nsenter;  }
sudo DOCKER_HOST=$DOCKER_HOST docker build -rm -t='medined/accumulo' .
sudo DOCKER_HOST=$DOCKER_HOST docker run -d --name=accbuild -h=MYHOSTNAME -p=127.0.0.10:2244:22 medined/accumulo /usr/bin/supervisord -n
sleep 5
ssh -i dotssh/accumulo -p 2244 root@127.0.0.10 /docker/init_accumulo.sh
sudo DOCKER_HOST=$DOCKER_HOST docker commit --author="David Medinets <david.medinets@gmail.com>" accbuild medined/accumulo
sudo DOCKER_HOST=$DOCKER_HOST docker stop accbuild || :
sleep 2
sudo DOCKER_HOST=$DOCKER_HOST docker rm accbuild || :
