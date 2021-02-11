#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../common/common.sh

echo
(exist_cmd minikube) || {
  echo "INSTALL MINIKUBE";
  curl -fSLo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-${MY_OS}-amd64;
  chmod +x minikube;
  sudo mv minikube /usr/local/bin
}


(exist_cmd kubectl) || {
  echo "INSTALL KUBECTL";
  ## if [ "$MY_OS" = "linux" ]; then
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

(exist_cmd kubectx) || {
  echo "INSTALL KUBECTX/KUBENS";
  if is_macos; then
    sudo port install kubectx;
  fi

  if is_linux; then
    if is_ubuntu; then
      sudo apt install kubectx;
    fi
    if is_arch; then
      sudo pacman -S kubectx;
    fi
  fi
}

