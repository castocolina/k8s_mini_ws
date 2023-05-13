#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

mkdir -p tmp

function install_minikube {
  echo "INSTALL MINIKUBE";
  curl -fSLo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-${MY_OS}-amd64;
  chmod +x minikube;
  sudo mv minikube /usr/local/bin
  minikube version
}

echo

(exist_cmd minikube) && {
  echo -n "UPDATE minikube? (y/n) > "
  read to_update
  if is_true $to_update; then
    install_minikube
  fi
}
(exist_cmd minikube 1> /dev/null) || install_minikube

wait_for_enter

function install_kubeseal () {
  echo "INSTALL KUBESEAL";
  release=$(get_github_latest_release "bitnami-labs/sealed-secrets" "v0.20.1")
  release_short="${release:1}"
  echo "VERSION ($release) == [$release_short]"
  #            https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.20.5/kubeseal-0.20.5-linux-amd64.tar.gz
  KUBESEAL_URL=https://github.com/bitnami-labs/sealed-secrets/releases/download/${release}/kubeseal-${release_short}-${MY_OS}-amd64.tar.gz
  curl -fSLo tmp/kubeseal.tar.gz $KUBESEAL_URL;
  tar -zxvf tmp/kubeseal.tar.gz -C tmp
  ls -la tmp/kubeseal
  sudo mv tmp/kubeseal /usr/local/bin;
}

(exist_cmd kubeseal) && {
  echo -n "UPDATE kubeseal? (y/n) > "
  read to_update
  if is_true $to_update; then
    install_kubeseal
  fi
}
(exist_cmd kubeseal 1> /dev/null) || install_kubeseal

wait_for_enter

function install_kubectl() {
  echo "INSTALL KUBECTL";
  if is_linux; then
    if is_ubuntu; then
      sudo apt-get install -y apt-transport-https;
      sudo apt-get install -y kubectl;
    fi
  fi
  
  latest=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt);
  URL="https://storage.googleapis.com/kubernetes-release/release/${latest}/bin/${MY_OS}/amd64/kubectl"
  curl -fSLO $URL
  
  chmod +x ./kubectl;
  sudo mv ./kubectl /usr/local/bin/kubectl;
}

(exist_cmd kubectl) && {
  echo -n "UPDATE kubectl? (y/n) > "
  read to_update
  if is_true $to_update; then
    install_kubectl
  fi
}
# (exist_cmd kubectl 1> /dev/null) || install_kubectl

wait_for_enter


function install_kubectx() {
  echo "INSTALL KUBECTX/KUBENS";
  if is_macos; then
    sudo port install kubectx;
  fi

  if is_linux; then
    if is_ubuntu; then
      sudo apt install kubectx || sudo snap install kubectx --classic;
    fi
    if is_arch; then
      sudo pacman -S kubectx;
    fi
  fi
}

(exist_cmd kubectx) && {
  echo -n "UPDATE kubectx? (y/n) > "
  read to_update
  if is_true $to_update; then
    install_kubectx
  fi
}
(exist_cmd kubectx 1> /dev/null) || install_kubectx

wait_for_enter


