echo "DEPLOYING CONTAINERS"
sleep 2
docker-compose -p 295fs -f docker-compose-onpremise.yml up -d

#docker exec -it mongodb mongo localhost:27017/TopicstoreDB /docker-entrypoint-initdb.d/mongo-initutf8.js
