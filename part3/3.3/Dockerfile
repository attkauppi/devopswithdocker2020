FROM docker

RUN apk add git

COPY pull_from_git_push_to_dockerhub.sh .

RUN chmod +x ./pull_from_git_push_to_dockerhub.sh

ENTRYPOINT["pull_from_git_push_to_dockerhub.sh"]