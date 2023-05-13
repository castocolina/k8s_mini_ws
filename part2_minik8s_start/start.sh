#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

### https://minikube.sigs.k8s.io/docs/start/

export K8_MINIK_RAM_MB=8GB
export K8_MINIK_CPU_NUM=4
export K8_MINIK_DISK=25GB

# https://minikube.sigs.k8s.io/docs/handbook/troubleshooting/#enabling-debug-logs
export K8_LOG_LEVEL=2
# https://kubernetes.io/releases/
# https://github.com/kubernetes/sig-release/blob/master/releases/patch-releases.md#cadence
export K8_API_VERSION=v1.30.1; export K8_API_VERSION="";

# https://minikube.sigs.k8s.io/docs/drivers/
export K8_MINIKUBE_DRIVER=docker ## virtualbox, hyperkit

export K8_HOST_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
# if is_macos; then
#   export K8_MINIKUBE_DRIVER=hyperkit
# fi
# if is_linux; then
#   export K8_MINIKUBE_DRIVER=kvm2
#   sudo virsh net-autostart --network minikube-net
# fi  

# minikube stop --alsologtostderr -p $K8_PROFILE_NAME
printf "\n $CONSOLE_OUT_SEP_STR\n\n\n"

#minikube config set kubernetes-version $K8_API_VERSION
#minikube config set vm-driver $K8_MINIKUBE_DRIVER

# --memory 4096 --cpus 4
# --gpu --vm-driver=kvm2 --vm-driver=hyperkit
minikube start --alsologtostderr --v $K8_LOG_LEVEL -p $K8_PROFILE_NAME \
    --memory $K8_MINIK_RAM_MB --cpus $K8_MINIK_CPU_NUM --disk-size $K8_MINIK_DISK \
    --vm-driver $K8_MINIKUBE_DRIVER #--kubernetes-version $K8_API_VERSION

echo
echo 
wait_time 10
echo
kubectx $K8_PROFILE_NAME
echo

minikube addons enable metrics-server dashboard ingress --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME
# minikube addons enable dashboard --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME
# minikube addons enable ingress --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME
# # https://github.com/kubernetes/minikube/issues/1378#issuecomment-340789584
# source $BASEDIR/sleepwatcher.zsh

printf "\n\n$CONSOLE_OUT_SEP_STR\n ::: kubectl:\n "
minikube kubectl version
printf "\n ::: minikube:\n "
minikube version
printf "%s\n\n" "${CONSOLE_OUT_SEP_STR}"

printf "\n\n ${CONSOLE_OUT_SEP_STR}\n ::: KUBE IP\n\n"
echo "$(minikube ip --v=$K8_LOG_LEVEL -p $K8_PROFILE_NAME)"
echo "PATH HTTP: http://$(minikube ip -p $K8_PROFILE_NAME)"
echo "PATH HTTPS: https://$(minikube ip -p $K8_PROFILE_NAME)"
printf "\n ${CONSOLE_OUT_SEP_STR}\n\n"
printf "\n\n\n\t TO OPEN DASHBOARD type on console:\n"
printf "\t minikube dashboard -p ${K8_PROFILE_NAME}\n\n\n${CONSOLE_OUT_SEP_STR}\n\n"
