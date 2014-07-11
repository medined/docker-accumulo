# Accumulo in Docker

This project provides a single-node Accumulo instance. It is based on the work at 
https://github.com/sroegner/docker-builds.

You can spinup as many Accumulo instances as you'd like and they'd run side-by-side. 
On my laptop each instance takes about 250 milliseconds to start but about 3 seconds 
for the processes to connect to each other.

As of July 11, each Accumulo container gets it own bridge network. This paves
the way for creating a multi-node Accumulo system. Each set of Docker containers
would communicate across its own bridge.

## Preparation

There are two ways to communicate with the Docker daemon. You can use a UNIX socket or a port. If you use a port, then set DOCKER_HOST like this:

```
export DOCKER_HOST="tcp://0.0.0.0:4243"
```

## Build Image

```
./make_image.sh
```

## Run Image

```
./make_container.sh [host name] [image name] [[brige name] [Class C subnet]
```

Note that a bridge name must begin with "br". For example,

```
./make_container.sh grail grail brgrail 10.0.10
```

You can see the bridge network from within the container. It looks like this:

```
$ ./enter_image.sh grail
# ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 9A:C0:FD:22:9E:A6  
          inet addr:10.0.10.1  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::98c0:fdff:fe22:9ea6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:251 errors:0 dropped:0 overruns:0 frame:0
          TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:46809 (45.7 KiB)  TX bytes:690 (690.0 b)
```

## Clean Image

```
./make_clean.sh [image name]
```

This script just wraps the 'docker stop' and 'docker rm' commands. 

## Enter Image

```
./enter_images.sh [image name]
```

This script uses the 'nsenter' command to join the namespace of a running container. It gives you a bash prompt within the confines of the container. Very handy for debugging!

## 'docker ps' of Six Running Containers

```
david@zareason-verix545:~/projects/docker-builds/accumulo$ docker ps
CONTAINER ID        IMAGE                      COMMAND             CREATED             STATUS              PORTS                                                                                                                                                                                                                                                                                                                                    NAMES
8fb45e05a194        medined/accumulo:latest    /run.sh walt        2 minutes ago       Up 2 minutes        0.0.0.0:49296->10020/tcp, 0.0.0.0:49297->19888/tcp, 0.0.0.0:49298->8020/tcp, 0.0.0.0:49299->8025/tcp, 0.0.0.0:49300->8050/tcp, 0.0.0.0:49301->2181/tcp, 0.0.0.0:49302->22/tcp, 0.0.0.0:49303->50070/tcp, 0.0.0.0:49304->50090/tcp, 0.0.0.0:49305->50095/tcp, 0.0.0.0:49306->8030/tcp, 0.0.0.0:49307->8088/tcp, 0.0.0.0:49308->8141/tcp   walt                
d317a83cb91a        sroegner/accumulo:latest   /run.sh paul        10 minutes ago      Up 10 minutes       0.0.0.0:49283->10020/tcp, 0.0.0.0:49284->50070/tcp, 0.0.0.0:49285->50090/tcp, 0.0.0.0:49286->50095/tcp, 0.0.0.0:49287->8025/tcp, 0.0.0.0:49288->19888/tcp, 0.0.0.0:49289->2181/tcp, 0.0.0.0:49290->22/tcp, 0.0.0.0:49291->8020/tcp, 0.0.0.0:49292->8030/tcp, 0.0.0.0:49293->8050/tcp, 0.0.0.0:49294->8088/tcp, 0.0.0.0:49295->8141/tcp   paul                
0d4d0fbf5416        sroegner/accumulo:latest   /run.sh david       12 minutes ago      Up 12 minutes       0.0.0.0:49270->19888/tcp, 0.0.0.0:49271->22/tcp, 0.0.0.0:49272->50090/tcp, 0.0.0.0:49273->50095/tcp, 0.0.0.0:49274->8020/tcp, 0.0.0.0:49275->8025/tcp, 0.0.0.0:49276->8050/tcp, 0.0.0.0:49277->8088/tcp, 0.0.0.0:49278->10020/tcp, 0.0.0.0:49279->2181/tcp, 0.0.0.0:49280->50070/tcp, 0.0.0.0:49281->8030/tcp, 0.0.0.0:49282->8141/tcp   david               
c3c908473ce8        sroegner/accumulo:latest   /run.sh charlie     15 minutes ago      Up 15 minutes       0.0.0.0:49257->10020/tcp, 0.0.0.0:49258->19888/tcp, 0.0.0.0:49259->50095/tcp, 0.0.0.0:49260->8020/tcp, 0.0.0.0:49261->8025/tcp, 0.0.0.0:49262->2181/tcp, 0.0.0.0:49263->22/tcp, 0.0.0.0:49264->50070/tcp, 0.0.0.0:49265->50090/tcp, 0.0.0.0:49266->8030/tcp, 0.0.0.0:49267->8050/tcp, 0.0.0.0:49268->8088/tcp, 0.0.0.0:49269->8141/tcp   charlie             
176d46738968        sroegner/accumulo:latest   /run.sh harry       15 minutes ago      Up 15 minutes       0.0.0.0:49244->2181/tcp, 0.0.0.0:49245->22/tcp, 0.0.0.0:49246->50070/tcp, 0.0.0.0:49247->8020/tcp, 0.0.0.0:49248->8025/tcp, 0.0.0.0:49249->8050/tcp, 0.0.0.0:49250->8088/tcp, 0.0.0.0:49251->10020/tcp, 0.0.0.0:49252->19888/tcp, 0.0.0.0:49253->50090/tcp, 0.0.0.0:49254->50095/tcp, 0.0.0.0:49255->8030/tcp, 0.0.0.0:49256->8141/tcp   harry               
954e3777b19f        sroegner/accumulo:latest   /run.sh grail       16 minutes ago      Up 16 minutes       0.0.0.0:49231->50070/tcp, 0.0.0.0:49232->50090/tcp, 0.0.0.0:49233->8020/tcp, 0.0.0.0:49234->8050/tcp, 0.0.0.0:49235->8088/tcp, 0.0.0.0:49236->8141/tcp, 0.0.0.0:49237->10020/tcp, 0.0.0.0:49238->19888/tcp, 0.0.0.0:49239->2181/tcp, 0.0.0.0:49240->22/tcp, 0.0.0.0:49241->50095/tcp, 0.0.0.0:49242->8025/tcp, 0.0.0.0:49243->8030/tcp   grail               
```

