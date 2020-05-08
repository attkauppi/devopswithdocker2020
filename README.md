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

[Dockerfile](1.14/Dockerfile)

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