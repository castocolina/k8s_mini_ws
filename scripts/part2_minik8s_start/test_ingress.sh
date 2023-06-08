#!/bin/bash
BASEDIR=$(dirname "$0")
source $BASEDIR/../commons/common.sh
source $BASEDIR/../commons/colors.sh

echo
kubectx ${K8_PROFILE_NAME}
echo

minikube -p ${K8_PROFILE_NAME} kubectl -- create deployment web --image=gcr.io/google-samples/hello-app:1.0
wait_for_enter
minikube -p ${K8_PROFILE_NAME} kubectl -- expose deployment web --type=NodePort --port=8080
wait_for_enter
minikube -p ${K8_PROFILE_NAME} kubectl -- get service web
wait_for_enter
minikube -p ${K8_PROFILE_NAME} service web --url
SERVICE_URL=$(minikube -p ${K8_PROFILE_NAME} service web --url)
curl "${SERVICE_URL}"
wait_for_enter

minikube -p ${K8_PROFILE_NAME} kubectl -- apply -f https://k8s.io/examples/service/networking/example-ingress.yaml
wait_for_enter

wait_time 5
minikube -p ${K8_PROFILE_NAME}  kubectl get ingress
echo; echo;

wait_for_enter
text_w_color "\n\nIngress OUT:\n\n" "BYellow" "On_IWhite"
curl --resolve "hello-world.info:80:$( minikube -p ${K8_PROFILE_NAME} ip )" -i http://hello-world.info

echo
minikube -p ${K8_PROFILE_NAME} kubectl -- delete ingress example-ingress
minikube -p ${K8_PROFILE_NAME} kubectl -- delete service web
minikube -p ${K8_PROFILE_NAME} kubectl -- delete deployment web

