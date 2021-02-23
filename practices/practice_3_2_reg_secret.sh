#!/bin/bash

mkdir -p tmp
BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

REG_SERVER=grc.io/example.com
REG_USER=castocolina@example.com
REG_PASSWD=

echo -n "ENTER YOUR USERNAME (default: '${REG_USER}' > "
read -r uinput

[ -n "${uinput}" ] && REG_USER=${uinput}
unset uinput

echo -n "ENTER YOUR PASSWORD > "
read -r -s uinput

[ -n "${uinput}" ] && REG_PASSWD=${uinput} || { printf "\n\nYou need a password for registry\n\n"; exit 2; }
unset uinput

echo
echo "${REG_SERVER}"
echo "${REG_USER}"
echo

kubectl create secret docker-registry regcred-example \
    --docker-server=${REG_SERVER} \
    --docker-username=${REG_USER} \
    --docker-password=${REG_PASSWD} \
    --dry-run=client \
    --output=yaml \
    --namespace=workshop-ns > tmp/docker-auth-cred.yaml

cat tmp/docker-auth-cred.yaml
echo

CONF_64=$(cat /tmp/docker-auth-cred.yaml | grep ".dockerconfigjson:" | cut -d':' -f2)
echo ${CONF_64}
echo

CONF_PLAIN=$(echo ${CONF_64} | base64 -i --decode)
(exist_cmd jq && echo $CONF_PLAIN | jq) \
    || echo ${CONF_PLAIN}

## echo ${DKR_CONFIG} > authCred.yaml


### HOW USE, go to https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret


echo