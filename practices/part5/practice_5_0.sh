#!/bin/bash
BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

# create application stack
kubectl apply -f ./practices/part5/practice_5_1_config.yaml
kubectl delete -f ./practices/part5/practice_5_1_deploy.yaml
kubectl apply -f ./practices/part5/practice_5_1_deploy.yaml
kubectl apply -f ./practices/part5/practice_5_1_service.yaml

echo
echo 
wait_time 10
echo
kubectl get pods

kubectl exec -n workshop-ns volumedemo1* -- bash -c "ls /var/log; echo; cat /var/log/*"

set -v
URL_NODE_PORT_RANDOM=$(minikube service --url -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}" volumedemo1-service-node-port-random)
echo ${URL_NODE_PORT_RANDOM}

echo
kubectl get service -n "${K8_NAMESPACE}" -o wide

echo
minikube service list -p "${K8_PROFILE_NAME}" -n "${K8_NAMESPACE}"
echo


echo
echo "try with NODE PORT RANDOM URL"

curl -v "${URL_NODE_PORT_RANDOM}"
set +v
printf "\n\n\n\n"

############################################################################

kubectl create configmap node-app-from-files -n workshop-ns \
    --from-file=practices/part5/demo/

kubectl apply -f ./practices/part5/practice_5_2_0_storage.yaml
kubectl apply -f ./practices/part5/practice_5_1_config.yaml
kubectl delete -f ./practices/part5/practice_5_2_deploy.yaml
kubectl apply -f ./practices/part5/practice_5_2_deploy.yaml
kubectl apply -f ./practices/part5/practice_5_2_service.yaml
