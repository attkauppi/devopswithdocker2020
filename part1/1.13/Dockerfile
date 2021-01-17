FROM openjdk:8

WORKDIR app

EXPOSE 8080

COPY ./spring-example-project/ .
RUN ls -a
RUN ./mvnw package

CMD ["java", "-jar", "./target/docker-example-1.1.3.jar"]