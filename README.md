# devopswithdocker2020



## Part 1

Exercises from [part 1](https://devopswithdocker.com/part1/)

### Exercises in between, have been done and can be found in their respective folders.

### [1.1](part1/1.1/1.1.md)

### [1.2](part1/1.2/1.2.md)

### [1.3](part1/1.3/1.3.md)

### [1.4](part1/1.4/1.4.md)

### [1.5](part1/1.5.md)

### [1.6](part1/1.6/1.6.md)

### [1.7](part1/1.7/1.7.md)

### [1.8](part1/1.8/1.8.md)

### [1.9](part1/1.9/1.9.md)

### [1.10](part1/1.10/1.10.md)

### [1.11](part1/1.11/1.11.md)

### 1.12

Commands used to run:

backend: docker run -p 8000:8000 backend_server

frontend: docker run -p 5000:5000 frontend_server

[Dockerfile.backend](/part1/1.12/Dockerfile.backend)
[Dockerfile.frontend](/part1/1.12/Dockerfile.frontend)

[.env](/part1/1.12/.env)

### 1.13

Commands used to build:

```
docker build -t spring .
```

Commands used to run:

```
docker run --rm -p 8080:8080 spring
```

### 1.14

[Dockerfile](part1/1.14/Dockerfile)

When building the container, I received loads of error messages and the build wouldn't even finish. The main error message was:

```
rails aborted!
ArgumentError: Missing `secret_key_base` for 'production' environment, set this string with `rails credentials:edit`
```
Presumably this is some sort of a salt that needs to be set for the server to run. Therefore, I added this line in my Dockerfile to assign some value for the secret_key_base argument:

```
ENV SECRET_KEY_BASE=tositosisalainen
```

Run:
```
docker run --rm -p 3000:3000 rails
```

### 1.15

[Dockerfile](part1/1.15/Dockerfile)

Dockerhub project available [here](https://hub.docker.com/repository/docker/arikaupp/flask_server).

This is a very minimal flask server running inside a docker container using a python 3.7 image. By default, flask uses port 5000.

To run the server, use the following command:

```
docker run -p 5000:5000 tag_name/container_id
```

### 1.16

The Heroku app is running [here](https://dockerdevops-herokuexample.herokuapp.com/).

In addition to creating a new app on Heroku, it was deployed with the following commands:

```
$ docker pull devopsdockeruh/heroku-example
$ docker tag devopsdockeruh/heroku-example registry.heroku.com/dockerdevops-herok$
$ heroku login
$ heroku container:login
$ docker push registry.heroku.com/dockerdevops-herokuexample/web
$ heroku container:release web --app dockerdevops-herokuexample
```


## Part 2

### 2.1

[docker-compose.yml](part2/2.2/docker-compose.yml)

Logs:

```
Mon, 11 May 2020 18:13:13 GMT
Mon, 11 May 2020 18:13:16 GMT
Mon, 11 May 2020 18:13:19 GMT
Mon, 11 May 2020 18:13:22 GMT
Secret message is:
"Volume bind mount is easy"
Mon, 11 May 2020 18:13:28 GMT
Mon, 11 May 2020 18:13:31 GMT
```

### 2.2

[docker-compose.yml](part2/2.3/docker-compose.yml)

### 2.3

[docker-compose.yml](part2/2.3/docker-compose.yml)

### 2.4

The only command used - in addition to cloning the application from git - was:

```
docker-compose up -d --scale compute=3
```

Not sure, if I was meant to do something else as well, but that seemed to be enough to get the button to turn green.

### 2.5

[docker-compose.yml](part2/2.5/docker-compose.yml)

### 2.6

[docker-compose.yml](part2/2.6/docker-compose.yml)


### 2.7

[docker-compose.yml](part2/2.7/docker-compose.yml)

### 2.8

[docker-compose.yml](part2/2.8/docker-compose.yml)

[nginx.conf](part2/2.8/nginx.conf)

Nginx configuration can be seen here as well:

```
events { worker_connections 1024; }

http {
    server {
        listen 80;

        location / {
        proxy_pass http://frontend:5000/;
        }

        location /api/ {
        proxy_pass http://backend:8000/;
        }
    }
}
```

### 2.9

[docker-compose.yml](part2/2.9/docker-compose.yml)

### 2.10

I removed the environment variable API_URL's definition from frontend's Dockerfile and only defined it in docker-compose.yml, but modified it so it points straight to  http://localhost:80/api due to nginx being now in use.

After that, everything seemed to work just fine.

[Backend's dockerfile](part2/2.10/Dockerfile.backend): 

```
FROM ubuntu:16.04

WORKDIR /mydir

COPY . .

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs

ENV FRONT_URL=http://localhost:5000
RUN npm install

EXPOSE 8000

ENTRYPOINT npm start
```

[Frontend's dockerfile](part2/2.10/Dockerfile.frontend):

```
FROM ubuntu:16.04

WORKDIR /mydir
COPY . .

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get -y install nodejs

RUN node -v && npm -v

# This was commented out in 2.10. API_URL is now defined in docker-compose.yml
#ENV API_URL=http://localhost:8000
RUN npm install

EXPOSE 5000

ENTRYPOINT npm start
```

[docker-compose.yml](part2/2.9/docker-compose.yml):

```

version: '3.5'

services:
    backend:
        # Works either way, with a prebuilt image or by building the frontend here
        #image: 'backend'
        build:
            ./backend-example-docker
        environment:
            - REDIS=redis
            - DB_HOST=postgres
            - DB_NAME=postgres
            - DB_USERNAME=postgres
            - DB_PASSWORD=example
        depends_on: 
            - postgres
        volumes:
            - ./logs.txt:/usr/app/logs.txt
        container_name: backend
        tty: true
        command: npm start
    
    frontend:
        # Works either way, with a prebuilt image or by building the frontend here
        #image: 'frontend'
        build:
            ./frontend-example-docker
        environment:
            - API_URL=http://localhost:80/api
        container_name: frontend
        tty: true
        command: npm start
    
    redis:
        image: 'redis'

    postgres:
        image: postgres
        restart: unless-stopped
        environment:
            POSTGRES_PASSWORD: example
        volumes:
            - ./database:/var/lib/postgresql/data

    nginx:
        image: nginx
        environment:
            - NGINX_HOST=localhost
            - NGINX_PORT=80
        ports:
            - 80:80
        container_name: nginx
        depends_on:
            - frontend
            - backend
        volumes:
            - ./nginx.conf:/etc/nginx/nginx.conf:ro
        restart: always
```

## Part 3

### 3.1

Results: 

REPOSITORY                                           TAG                 IMAGE ID            CREATED             SIZE
backend                                              latest              5cfd59638a84        8 minutes ago       308MB
backend_old                                          latest              31af1ebf5e64        14 minutes ago      337MB
frontend_old                                         latest              1b88702d89d0        26 minutes ago      516MB
frontend                                             latest              46b483e93042        4 minutes ago       488MB

Dockerfiles:

* [old frontend Dockerfile](part3/3.1/Dockerfile.front_old)
* [new frontend Dockerfile](part3/3.1/Dockerfile.front_new)
* [old backend Dockerfile](part3/3.1/Dockerfile.backend_old)
* [new backend Dockerfile](part3/3.1/Dockerfile.backend_new)

Results also [here](part3/3.1/results.txt).

### 3.2 - A simple flask application on heroku


Github repository is [here](https://github.com/attkauppi/flask_example/).

Flask application running on heroku can be found [here](https://flaskexampledevops.herokuapp.com/).

Dockerfile looked like this:

```
FROM python:3.7-alpine

WORKDIR /app

COPY . .

RUN pip install -U Flask gunicorn

EXPOSE 5000:5000
ENTRYPOINT python wsgi.py
```

And the config.yml for circleci looked like this:

```
version: 2.1
orbs:
  heroku: circleci/heroku@0.0.10
workflows:
  heroku_deploy:
    jobs:
      - heroku/deploy-via-git
```
### 3.3 - simple build service

Answer for exercise 3.3 and further documentation can be found [here](part3/3.3/3.3.md)

The example project I used was the ruby project from part1, exercise 1.14 (link to github)[https://github.com/docker-hy/rails-example-project]. I cloned the project to my own github and used the Dockerfile I submitted as an answer to [exercise 1.14](part1/1.14/Dockerfile)

You can find more documentation in the first link mentioned under this subheading.

[Link to Dockerhub project created in the exercise](https://hub.docker.com/repository/docker/arikaupp/devopsrubyexample).

### 3.4 - non-root users

[Dockerfile for backend](part3/3.4/Dockerfile.backend_new)

[Dockerfile for frontend](part3/3.4/Dockerfile.frontend_new)

The users of both are non-root.

### 3.5

Original sizes:

* Frontend](part3/3.5/Dockerfile.frontend: 493 MB
* Backend: 299 MB

Improved:

* [Frontend](part3/3.5/Dockerfile.frontend): 301 MB
* [Backend](part3/3.5/Dockerfile.backend): 124

### 3.6

[Dockerfile][part3/3.6/Dockerfile]

```
FROM node:alpine as build-stage

ENV API_URL=http://localhost:8000
EXPOSE 5000

WORKDIR /app

RUN apk add git --no-cache && \
    git clone https://github.com/docker-hy/frontend-example-docker.git /app && \
    npm install && \
    npm run build

FROM nginx:alpine

EXPOSE 80

COPY --from=build-stage /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
```

### 3.7

I used the spring project from part1 of the course (exercise 1.13, (github)[https://github.com/docker-hy/spring-example-project]).

This is my [old Dockerfile](part3/3.7/Dockerfile.old):

```
FROM openjdk:8

WORKDIR app

EXPOSE 8080

COPY ./spring-example-project/ .
RUN ls -a
RUN ./mvnw package

CMD ["java", "-jar", "./target/docker-example-1.1.3.jar"]
```
It's size was 599 MB

This is my [new Dockerfile](part3/3.7/Dockerfile)

```
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
```
It's size is 141 MB