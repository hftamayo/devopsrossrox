#!/bin/bash

#stage 0: enviro vars
BC_PROJECT="295devops"
HOME_PROJECT="desafio02"
GH_REPO="https://github.com/hftamayo/devopsrossrox.git"
BRANCH_REPO="grial01"


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
cd 295topics-fullstack

docker build -t 295fs_be:stable -f Dockerfile.be .
sleep 5

docker build -t 295fs_fe:stable -f Dockerfile.fe .
sleep 5

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
sleep 5

docker tag 295fs_be:stable hftamayo/295fs_be:stable
sleep 2
docker push hftamayo/295fs_be:stable
sleep 5

docker tag 295fs_fe:stable hftamayo/295fs_fe:stable
sleep 2
docker push hftamayo/295fs_fe:stable
sleep 5

echo "BUILD AND PUSH script finished"
docker logout
sleep 2

echo "DEPLOYING CONTAINERS"
sleep 2
docker-compose -p 295fs  up -d
sleep 5
echo "THE APPLICATION IS UP AND RUNNING"
sleep 1
