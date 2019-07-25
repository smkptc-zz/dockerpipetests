FROM maven:3.5.3-jdk-8-alpine
COPY ./. /
ENTRYPOINT ["/bin/bash", "-c", "mvn test"]