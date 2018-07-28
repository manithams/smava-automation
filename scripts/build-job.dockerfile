FROM $DOCKER_REGISTRY:8-jdk
COPY helloworld.war /app/
WORKDIR /app/ 
CMD java -jar /app/helloworld.war
EXPOSE 8080
