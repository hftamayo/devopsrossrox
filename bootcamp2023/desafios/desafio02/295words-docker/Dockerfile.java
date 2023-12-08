#################### MAVEN BUILD STAGE ####################

FROM maven:3.8.5-openjdk-18 AS build

RUN mkdir -p /opt/295words; exit 0

WORKDIR /opt/295words
COPY api/src ./src
COPY api/pom.xml .
RUN mvn clean package

################# JDK RUN STAGE ################### 
FROM amazoncorretto:18
RUN yum  install -y net-tools

WORKDIR /opt/295words
COPY --from=build /opt/295words/target/words-jar-with-dependencies.jar ./words001.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "./words001.jar"]
