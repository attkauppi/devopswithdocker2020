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



