#!/bin/bash

#stage 1: cloning the repo


#Build and Push BackEnd 295fullstack
docker build -t 295fs_be:stable Dockerfile.be
sleep 5

docker build -t 295fs_fe:stable Dockerfile.fe
sleep 5

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
sleep 5

docker push 295fs_be:stable
sleep 5

docker push 295fs_fe:stable
