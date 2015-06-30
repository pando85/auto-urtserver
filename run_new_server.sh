#!/bin/bash
set -e
BASE_DIR=$(dirname -- $(readlink -fn -- "$0"))

SERVER_NAME=$1
SERVER_PORT=$2
SERVER_PATH=${BASE_DIR}/../$SERVER_NAME

NEW_PASSWORD=$(date | md5sum |cut -d " " -f 1)

mkdir $SERVER_PATH

cp -r conf $SERVER_PATH

sed -i "s/PASSWORD/$NEW_PASSWORD/g" $SERVER_PATH/{q3ut4/server.cfg,spunky-conf/conf/settings.conf}

docker run -d -v $SERVER_PATH/q3ut4:/q3ut4 -e URT_PORT=$SERVER_PORT \
           --net host --name="$SERVER_NAME" urbanterror-server

docker run -d -v $SERVER_PATH/spunky-conf:/root/spunkybot \
           -v $SERVER_PATH/q3ut4:/root/q3ut4 --name="${SERVER_NAME}_spunkybot"\
           --net=host spunkybot /root/spunkybot
