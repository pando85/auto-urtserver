#!/bin/bash
set -e

sudo docker build -t urbanterror-server github.com/pando85/docker-UrbanTerror

#docker build -t b3 github.com/pando85/b3-Dockerfiles
sudo docker build -t spunkybot github.com/pando85/docker-spunkybot