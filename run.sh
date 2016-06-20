
#this allows rndc to run on host outside docker
sudo ln -s `pwd`/etc/./ /etc/bind

docker pull lansmash/bind:latest || docker build -t lansmash/bind github.com/lansmash/docker-bind

docker run --name bind -d --restart=always   \
  --publish 53:53/tcp --publish 53:53/udp --publish 127.0.0.1:953:953/tcp  \
  --volume ~/ls-bind/:/data lansmash/bind:latest && 

docker logs -f bind
