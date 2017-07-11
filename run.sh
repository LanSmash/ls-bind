#!/bin/bash

#find directory this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GITDIR=$DIR

#this allows rndc to run on host outside docker
sudo ln -sf $GITDIR/etc/rndc.key /etc/bind/rndc.key

echo recreating blacklist
$GITDIR/blacklist/blacklist.sh

docker pull lansmash/docker-bind:latest || docker build -t lansmash/docker-bind github.com/lansmash/docker-bind

docker stop bind
docker rm bind
docker run --name bind -d --restart=always   \
  --publish 53:53/tcp --publish 53:53/udp --publish 127.0.0.1:953:953/tcp  \
  --volume $GITDIR/etc:/etc/bind --volume /etc/localtime:/etc/localtime \
  lansmash/docker-bind:latest && 

docker logs -f bind
