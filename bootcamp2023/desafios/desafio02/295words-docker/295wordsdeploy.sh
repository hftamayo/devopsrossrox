cd ~/295devops/desafio02/bootcamp2023/desafios/desafio02/295words-docker

mkdir data
mkdir data/pgdata

sleep 3

docker-compose -p 295words -f docker-compose-images.yml  up -d
sleep 5
echo "THE APPLICATION IS UP AND RUNNING"
sleep 1







