# devopswithdocker2020



## Part 1

Exercises from [part 1](https://devopswithdocker.com/part1/)


### 1.12

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

[Flask application] runnin on heroku can be found [here](https://flaskexampledevops.herokuapp.com/).

Dockerfile looked like this:

```
FROM ubuntu:16.04

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install python3 python3-flask python3-gunicorn -y

EXPOSE 5000:5000
ENTRYPOINT python3 wsgi.py
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
