FROM ubuntu:16.04

WORKDIR /mydir

COPY . .

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs
RUN npm install
EXPOSE 8000

#CMD ["npm start"]
ENTRYPOINT ["/usr/bin/npm"]
CMD ["start"]
