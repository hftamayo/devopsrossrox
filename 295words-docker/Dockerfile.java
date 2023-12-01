#################### MAVEN BUILD STAGE ####################

FROM maven:3.8.5-openjdk-17 AS build

RUN mkdir -p /opt/295words; exit 0

WORKDIR /opt/295words
COPY api/src ./src
COPY api/target ./target
COPY api/pom.xml .
RUN mvn clean package

################# JDK RUN STAGE ################### 
FROM amazoncorretto:17
WORKDIR /opt/295words
COPY --from=build /opt/295words/target/words.jar ./words001.jar
ENTRYPOINT ["java", "-jar", "./words001.jar"]


