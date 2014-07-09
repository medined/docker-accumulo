# Accumulo in Docker

This project provides a single-node Accumulo instance. It is based on the work at https://github.com/sroegner/docker-builds.

## Build Image

```
./make_image.sh
```

## Run Image

```
./make_container.sh [host name] [image name]
```

You must specify a host name and an image name when you start an Accumulo container. Doing some allows you to start more than one Accumulo container at the same time.

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
