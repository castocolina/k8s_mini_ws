#!/bin/bash
BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

# create application stack
kubectl apply -f ./practices/practice_4.yaml

echo
echo 
wait_time 10
echo
kubectl get pods

echo
kubectl get service -n "${K8_NAMESPACE}" -o wide

echo
minikube service list -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}"
echo


echo
URL_NODE_PORT=$(minikube service --url -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}" frontend-node-port)
URL_NODE_PORT_RANDOM=$(minikube service --url -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}" frontend-node-port-random)
URL_LOAD_BAL=$(minikube service --url -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}" frontend-load)
EXTERNAL_IP=$(minikube ip -p "${K8_PROFILE_NAME}")
echo

echo
echo "GET EXTERNAL PORT FOR NODE PORT"
set -v
curl -v "http://${EXTERNAL_IP}:30800"
set +v
printf "\n\n\n\n"

echo
echo "try with NODE PORT URL"
set -v
curl -v "${URL_NODE_PORT}"
set +v
printf "\n\n\n\n"

echo
echo "try with LOAD BALANCE URL"
set -v
curl -v "${URL_LOAD_BAL}"
set +v
printf "\n\n\n\n"

echo
echo "try with NODE PORT RANDOM URL"
set -v
curl -v "${URL_NODE_PORT_RANDOM}"
set +v
printf "\n\n\n\n"

echo
echo "try with NODE IP and ingress path"
set -v
curl -v "http://${EXTERNAL_IP}:80/testpath"
set +v
printf "\n\n\n\n"
