#!/bin/bash
set -e

# Make sure only root can run this script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

BASE_DIR="$(dirname -- $(readlink -fn -- "$0"))"

SERVER_NAME="$2"
SERVER_PORT=$3
 
SERVERS_PATH="$BASE_DIR/servers"
SERVER_PATH="$SERVERS_PATH/$SERVER_NAME"

CONFIG_PATH="$BASE_DIR/conf"
 
DOCKER_URT="${SERVER_NAME}_urtserver"
DOCKER_SPUNKYBOT="${SERVER_NAME}_spunkybot"


install(){
    docker build -t urbanterror-server github.com/pando85/docker-UrbanTerror

    #docker build -t b3 github.com/pando85/b3-Dockerfiles
    docker build -t spunkybot github.com/pando85/docker-spunkybot
}


init(){
    if [ "$SERVER_NAME" == "" ] || [ "$SERVER_PORT" == "" ]; then
        echo "Usage: $0 init <server-name> <server-port>" >&2
        exit 1
    fi
   
    NEW_PASSWORD=$(date | md5sum |cut -d " " -f 1)
    
    mkdir -p "$SERVERS_PATH"
    
    cp -r "$CONFIG_PATH" "$SERVER_PATH"
    
    sed -i "s/PASSWORD/$NEW_PASSWORD/g" "$SERVER_PATH"/{q3ut4/server.cfg,spunky-conf/conf/settings.conf}
    
    sed -i "s/PORT/$SERVER_PORT/g" "$SERVER_PATH/spunky-conf/conf/settings.conf"
    
    docker run -d -v "$SERVER_PATH"/q3ut4:/q3ut4 -v "$CONFIG_PATH"/maps:/maps -e URT_PORT=$SERVER_PORT \
                    --net=host --name="$DOCKER_URT" urbanterror-server
    
    sleep 15
    
    docker run -d -v "$SERVER_PATH"/spunky-conf:/root/spunkybot \
                    -v "$SERVER_PATH"/q3ut4:/root/q3ut4 --name="$DOCKER_SPUNKYBOT"\
                    --net=host spunkybot /root/spunkybot
}


remove(){
    if [ "$SERVER_NAME" == "" ]; then
        echo "Usage: $0 remove <server-name>" >&2
        exit 1
    fi
    
    rm -rf "$SERVER_PATH"
    
    docker stop "$DOCKER_URT"
    docker rm "$DOCKER_URT"
    
    docker stop "$DOCKER_SPUNKYBOT"
    docker rm "$DOCKER_SPUNKYBOT"
    
}

if [ "$1" = "install" ]; then
    install
elif [ "$1" = "init" ]; then
    init
elif [ "$1" = "remove" ]; then
    remove
else
    echo "Usage: $0 install|init|remove" >&2
    exit 1
fi
