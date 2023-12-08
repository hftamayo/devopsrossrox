cd ~/295devops/desafio02/bootcamp2023/desafios/desafio02/295words-docker

cp env.example .env
sed -i 's/API_USER=.*$/API_USER=mongodb:\/\/mongodb:27017/' ./.env
sed -i 's/API_PASSWORD=.*$/API_PASSWORD=mongodb:\/\/mongodb:27017/' ./.env
sed -i 's/API_DATABASE=.*$/API_DATABASE=TopicstoreDB/' ./.env
sed -i 's/API_HOST=.*$/API_HOST=0.0.0.0/' ./.env
sed -i 's/API_LOCAL_PORT=.*$/API_LOCAL_PORT=5000/' ./.env
sed -i 's/API_DOCKER_PORT=.*$/API_DOCKER_PORT=5000/' ./.env
sed -i 's/POSTGRES_PORT=.*$/POSTGRES_PORT=5000/' ./.env
sed -i 's/PG_LOCAL_PORT=.*$/PG_LOCAL_PORT=5000/' ./.env
sed -i 's/PG_DOCKER_PORT=.*$/PG_DOCKER_PORT=5000/' ./.env
sed -i 's/PG_USER=.*$/PG_USER=5000/' ./.env
sed -i 's/PG_PASSWORD=.*$/PG_PASSWORD=5000/' ./.env

docker-compose -p 295words -f docker-compose-images.yml  up -d
sleep 5
echo "THE APPLICATION IS UP AND RUNNING"
sleep 1







