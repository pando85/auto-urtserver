#!/bin/bash
set -e

if [ "x$1" == x ]; then
    echo "Usage: $0 <server-name>" >&2
    exit 1
fi

SERVER_NAME="$1"

BASE_DIR="$(dirname -- $(readlink -fn -- "$0"))"
SERVERS_PATH="$BASE_DIR/servers"
SERVER_PATH="$SERVERS_PATH/$SERVER_NAME"

DOCKER_URT="${SERVER_NAME}_urtserver"
DOCKER_SPUNKYBOT="${SERVER_NAME}_spunkybot"

rm -rf "$SERVER_PATH"

sudo docker stop "$DOCKER_URT"
sudo docker rm "$DOCKER_URT"

sudo docker stop "$DOCKER_SPUNKYBOT"
sudo docker rm "$DOCKER_SPUNKYBOT"