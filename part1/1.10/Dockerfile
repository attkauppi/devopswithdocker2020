FROM ubuntu:16.04

WORKDIR /mydir
COPY . .

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get -y install nodejs

RUN node -v && npm -v
RUN npm install
RUN npm run build
RUN npm install -g serve

EXPOSE 5000

ENTRYPOINT ["/usr/bin/serve"]
CMD ["-s", "-l", "5000", "dist"]
