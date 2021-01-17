FROM openjdk:8-jdk-alpine as build-stage

WORKDIR app

RUN apk add --no-cache git && \
    git clone https://github.com/docker-hy/spring-example-project.git /app && \
    ./mvnw package && \
    ls -a && \
    ls -a target && \
    rm -rf /var/cache/apk/*

FROM openjdk:8-jdk-alpine

COPY --from=build-stage app/target/docker-example-1.1.3.jar .

RUN adduser -D app && chown app docker-example-1.1.3.jar

USER app
EXPOSE 8080

CMD java -jar ./docker-example-1.1.3.jar