#!/bin/bash

#stage 0: enviro vars
BC_PROJECT="295devops"
HOME_PROJECT="desafio02"
GH_REPO="https://github.com/hftamayo/devopsrossrox.git"
BRANCH_REPO="desafio02"


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
	git clone $GH_REPO $BRANCH_REPO
	cd $BRANCH_REPO
	git checkout $BRANCH_REPO
fi

#stage 2: Build and Push BackEnd 295fullstack
docker build -t 295fs_be:stable Dockerfile.be
sleep 5

docker build -t 295fs_fe:stable Dockerfile.fe
sleep 5

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
sleep 5

docker push 295fs_be:stable
sleep 5

docker push 295fs_fe:stable
sleep 5

echo "BUILD AND PUSH script finished"
