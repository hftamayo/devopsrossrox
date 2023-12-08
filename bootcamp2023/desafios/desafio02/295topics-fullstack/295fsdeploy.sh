#!/bin/bash

cd ~/295devops/desafio02/bootcamp2023/desafios/desafio02/295topics-fullstack

mkdir data
mkdir data/mongodb_data

sleep 3

docker-compose -p 295fs -f docker-compose-onpremise.yml up -d

sleep 2
