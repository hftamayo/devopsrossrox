#!/bin/bash

#stage 0: enviro vars
BC_PROJECT="295words"
HOME_PROJECT="desafio02"
GH_REPO="https://github.com/hftamayo/devopsrossrox.git"
BRANCH_REPO="grial01"

#STAGE 1: install/update codebase
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

#STAGE 2: updates to the original codebase

cd 295words-docker
#updating db's seeding data
#TODO: this routine should be a transaction
original_sql="db/words.sql"
new_line="SET client_encoding = 'UTF8';"
echo $new_line > temp_sql
cat $original_sql >> temp_sql #concatenating the new file
mv temp_sql db/
mv db/temp_sql db/words.sql
echo "postgres script updated"

#creating a golang's mod file
cd frontend/
go mod init
cd ..

#STAGE #: docker images build and push
docker build -t 295words_be:stable -f Dockerfile.java .
sleep 5

docker build -t 295words_fe:stable -f Dockerfile.go .
sleep 5

docker build -t 295words_db:stable -f Dockerfile.pg .
sleep 5
echo "Docker images generated"

docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
sleep 5

docker tag 295words_be:stable hftamayo/295words_be:1.0.0
sleep 2
docker push hftamayo/295words_be:stable
sleep 5

docker tag 295words_fe:stable hftamayo/295words_fe:1.0.0
sleep 2
docker push hftamayo/295words_fe:stable
sleep 5

docker tag 295words_db:stable hftamayo/295words_db:1.0.0
sleep 2
docker push hftamayo/295words_db:stable
sleep 5

echo "Docker images built and pushed"
docker logout
sleep 2

echo "DEPLOYING CONTAINERS"
sleep 2
docker-compose -p 295words -f docker-compose-images.yml  up -d
sleep 5
echo "THE APPLICATION IS UP AND RUNNING"
sleep 1
