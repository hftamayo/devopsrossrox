#!/bin/bash

#Build and Push BackEnd 295fullstack
docker build -t 295fs_be:stable . #TODO: BEDockerfile
docker login --username=miusuario --password=mipassword

docker push 295fs_be:stable
