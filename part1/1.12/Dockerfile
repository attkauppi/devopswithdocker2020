FROM ubuntu:16.04

WORKDIR /mydir

COPY . .

RUN apt-get update && apt-get -y install curl supervisor && mkdir -p /var/log/supervisor && mkdir -p /etc/supervisor/conf.d
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs

# Frontend requirements
#RUN cd /mydir/frontend-example-docker
#RUN pwd
#RUN ls -l

# /mydir/frontend-example-docker/
RUN npm install ./frontend-example-docker
#RUN cd /mydir/frontend-example-docker
RUN npm run build ./frontend-example-docker/
#RUN cd ..
RUN npm install -g serve
#RUN cd /mydir
#RUN cd /mydir

EXPOSE 5000

# backend
#RUN npm install /mydir/backend-example-docker
#RUN cd ..

EXPOSE 8000

# Supervisor
ADD supervisor.conf /etc/supervisor.conf


#CMD ["/bin/bash"]
CMD ["supervisord", "-c", "/etc/supervisor.conf"]

