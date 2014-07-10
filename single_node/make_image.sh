#!/bin/bash

sudo docker run -v /usr/local/bin:/target jpetazzo/nsenter
sudo docker build -rm -t='medined/accumulo' .
sudo docker run -d --name=accbuild -h=MYHOSTNAME -p=127.0.0.10:2244:22 medined/accumulo /usr/bin/supervisord -n
sleep 5
ssh -i dotssh/accumulo -p 2244 root@127.0.0.10 /docker/init_accumulo.sh
sudo docker commit --author="David Medinets <david.medinets@gmail.com>" accbuild medined/accumulo
sudo docker stop accbuild || :
sleep 2
sudo docker rm accbuild || :
