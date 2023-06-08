#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../commons/common.sh

echo

printf "\n\n:: $SEPARATOR\n "
docker -v
docker compose version
docker run --rm hello-world
docker image rm -f hello-world

printf "\n\n:: $SEPARATOR\n minikube: "
minikube version

printf "\n:: $SEPARATOR\n kubectl: "
minikube kubectl version # --client --short

printf "\n:: $SEPARATOR\n kubeseal: "
kubeseal --version
printf "\n:: $SEPARATOR\n "

echo
