#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

echo

printf ":: $SEPARATOR\n minikube: "
minikube version
printf "\n:: $SEPARATOR\n kubectl: "
kubectl version --client --short

echo
