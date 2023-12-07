# DevOps Bootcamp 2023: Challenge 02 #

## Content ##
- Overview
- 295topics-fullstack
- 295words-docker
- References

## 1. Overview ##
In this branch you can find the source files and walkthroughs and technical references about 
how to create and deploy two multi layer monolith Web Application on Docker containers, the technical stack of
each application is the next:

### 1.1 295topics-fullstack ###
- Data Layer: MongoDB (local instance).
- Backend: Express + Typescript.
- Frontend: Node.JS + EJS Template.
- Mongo-Express: Tool for MongoDB Administration (similar to phpmyadmin / pgadmin.)
- On premise deployment each of the above layer belongs to a separate container. The automation script 
requires two variables (DOCKER_HUB_USERNAME and DOCKER_HUB_PASSWORD), they may be created in bash environment.
- On cloud: The first three containers will be deployed on Google Cloud Platform.

### 1.1 295words-docker ###
- Data Layer:
- Backend: 
- Frontend: 
- On premise deployment 
- On cloud: 

## 2. Project 1: 295topics-fullstack ##

### 2.1 Requirements ###
[requirements in spanish](https://github.com/hftamayo/devopsrossrox/blob/desafio02/295topics-fullstack/enunciadosp.md)

### 2.2 Walkthrough ###
* [Planning]()
* [Database]()
* [Backend]() 
* [Frontend]()
* [Automation on premise]()
* [Automation on cloud]()

### 2.3 Demo On Premise ###
* []()
* ![PR001]()

### 2.4 Demo On Cloud ###
* []()
* ![PR001]()

## 3. Project 2: 295 Words ##

### 3.1 Requirements ###
[requirements in spanish](https://github.com/hftamayo/devopsrossrox/blob/desafio02/295topics-fullstack/enunciadosp.md)

### 3.2 Walkthrough ###
* [Planning]()
* [Database]()
* [Backend]() 
* [Frontend]()
* [Automation on premise]()
* [Automation on cloud]()

### 3.3 Demo On Premise ###
* []()
* ![PR001]()

### 3.4 Demo On Cloud ###
* []()
* ![PR001]()

## 4. References ##
### Exercise 1: MongoDB+TS+Node ###
* [MongoDB-Express Admin Tool Official Repo](https://github.com/mongo-express/mongo-express)
* [Post on Stackoverflow about no fetching data from MongoDB](https://stackoverflow.com/questions/63460493/node-with-mongodb-atlas-docker-image-return-empty-array)
* [Personal Post on StackOverflow requesting help for fetching data from Mongo](https://stackoverflow.com/questions/77616244/getting-a-json-with-no-data-between-mongodb-container-and-tsexpress-container)
* [Matrix of Compatibility between MongoDB and Node's Mongo Driver](https://www.mongodb.com/docs/drivers/node/current/compatibility/)
* command for check mongodb status: docker exec -it mongodb bash -c "mongosh --eval 'db.adminCommand(\"ping\")'"

### Exercise 2: Golang+Java ###
* [Building fat jar files](https://jenkov.com/tutorials/maven/maven-build-fat-jar.html)
* [Adding manifest to the jar file](https://stackoverflow.com/questions/73143677/no-main-manifest-attribute-in-jar-file-error-in-maven-project)

