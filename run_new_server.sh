#!/bin/bash
set -e

if [ "x$1" == x ] || [ "x$2" == x ]; then
    echo "Usage: $0 <server-name> <server-port>" >&2
    exit 1
fi

SERVER_NAME="$1"
SERVER_PORT=$2

BASE_DIR="$(dirname -- $(readlink -fn -- "$0"))"
CONFIG_PATH="$BASE_DIR/conf"
SERVER_PATH="${BASE_DIR}/servers/$SERVER_NAME"

NEW_PASSWORD=$(date | md5sum |cut -d " " -f 1)

mkdir -p "$SERVER_PATH"

cp -r "$CONFIG_PATH" "$SERVER_PATH"

sed -i "s/PASSWORD/$NEW_PASSWORD/g" "$SERVER_PATH"/{q3ut4/server.cfg,spunky-conf/conf/settings.conf}

docker run -d -v "$SERVER_PATH"/q3ut4:/q3ut4 -e URT_PORT=$SERVER_PORT \
           --net host --name="$SERVER_NAME" urbanterror-server

docker run -d -v "$SERVER_PATH"/spunky-conf:/root/spunkybot \
           -v "$SERVER_PATH"/q3ut4:/root/q3ut4 --name="${SERVER_NAME}_spunkybot"\
           --net=host spunkybot /root/spunkybot
