#!/bin/bash

#stage 0: enviro vars
BC_PROJECT="295devops"
HOME_PROJECT="desafio02"
GH_REPO="https://github.com/hftamayo/devopsrossrox.git"
BRANCH_REPO="grialrevamp"


#stage 1: cloning the repo
cd $HOME

if [ -d $BC_PROJECT ]; then
	cd $BC_PROJECT
else
	mkdir $BC_PROJECT
	cd $BC_PROJECT
fi

if [ -d $HOME_PROJECT ]; then
	cd $HOME_PROJECT
	git checkout $BRANCH_REPO
	git pull
else
	git clone $GH_REPO $HOME_PROJECT
	cd $HOME_PROJECT
	git checkout $BRANCH_REPO
fi

#stage 2: Build and Push BackEnd 295fullstack
cd bootcamp2023/desafios/desafio02/295topics-fullstack

docker build -t 295mongodb:stable-1.0.0 -f Dockerfile.mongo .
sleep 5

docker build -t 295fs_be:stable-1.0.0 -f Dockerfile.be .
sleep 5

docker build -t 295fs_fe:stable-1.0.0 -f Dockerfile.fe .
sleep 5

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
sleep 5

docker tag 295mongodb:stable-1.0.0 hftamayo/295mongodb:stable-1.0.0
sleep 2
docker push hftamayo/295mongodb:stable-1.0.0
sleep 5

docker tag 295fs_be:stable-1.0.0 hftamayo/295fs_be:stable-1.0.0
sleep 2
docker push hftamayo/295fs_be:stable-1.0.0
sleep 5

docker tag 295fs_fe:stable-1.0.0 hftamayo/295fs_fe:stable-1.0.0
sleep 2
docker push hftamayo/295fs_fe:stable-1.0.0
sleep 5

echo "BUILD AND PUSH script finished"
docker logout
sleep 2

