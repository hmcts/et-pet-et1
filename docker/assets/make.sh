#!/bin/bash

DEFAULT_DOCKERREPO="docker.local:5000"
DEFAULT_DOCKERTAG="assets"

DOCKERFILE="docker/assets/Dockerfile"
DOCKERREPO="${DOCKERREPO:-$DEFAULT_DOCKERREPO}"
DOCKERTAG="${DOCKERTAG:-$DEFAULT_DOCKERTAG}"

[ ! -d "docker" ] && echo "Please run from git root" && exit 1

if [ -n "$1" ]; then 
  TAG="${DOCKERREPO}/${DOCKERTAG}:$1"
else 
  TAG="${DOCKERREPO}/${DOCKERTAG}"
fi

cp ${DOCKERFILE} .
docker build -t ${TAG} --force-rm=true .

if [ -z "$DOCKER_NOPUSH" ]; then
  echo "+ docker push ${TAG}"
  docker push ${TAG}
fi

if [ -z "$DOCKER_NORMI" ]; then
  echo "+ docker rmi ${TAG}"
  docker rmi ${TAG}
fi


