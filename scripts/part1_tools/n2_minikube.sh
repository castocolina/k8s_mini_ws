#!/bin/bash

BASEDIR=$(dirname "$0")
source $BASEDIR/../commons/common.sh
source $BASEDIR/../commons/colors.sh

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
  text_w_color "UPDATE minikube? (y/n) > " "Yellow"
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
  text_w_color "UPDATE kubeseal? (y/n) > " "Yellow"
  read to_update
  if is_true $to_update; then
    install_kubeseal
  fi
}
(exist_cmd kubeseal 1> /dev/null) || install_kubeseal

wait_for_enter

function install_kubectl() {
  text_w_color "INSTALL KUBECTL? (y/n) > " "Yellow"
  read to_update
  if is_false $to_update; then
    return 0;
  fi

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
  text_w_color "UPDATE kubectl? (y/n) > " "Yellow"
  read to_update
  if is_true $to_update; then
    install_kubectl
  fi
}

(exist_cmd kubectl 2> /dev/null) || install_kubectl

wait_for_enter


function install_kubectx() {
  echo "INSTALL KUBECTX/KUBENS";
  if is_macos; then
    brew install kubectx;
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
  text_w_color "UPDATE kubectx? (y/n) > " "Yellow"
  read to_update
  if is_true $to_update; then
    install_kubectx
  fi
}
(exist_cmd kubectx 1> /dev/null) || install_kubectx

function install_jq() {
  echo "INSTALL jq";
  JQ_URL=https://github.com/jqlang/jq/releases/download/jq-1.6/jq-linux64
  if is_macos; then
    JQ_URL=https://github.com/jqlang/jq/releases/download/jq-1.6/jq-osx-amd64
  fi

  mkdir -p tmp
  curl -fSL -o tmp/jq "${JQ_URL}"
  chmod +x tmp/jq
  if is_macos; then
    mv -v tmp/jq /usr/local/bin/jq
    ls -la /usr/local/bin/jq
  fi
  if is_ubuntu; then
    sudo mv -v tmp/jq /usr/bin/jq
    ls -la /usr/bin/jq
  fi
  jq --version
}

(exist_cmd jq) && {
  text_w_color "UPDATE jq? (y/n) > " "Yellow"
  read to_update
  if is_true $to_update; then
    install_jq
  fi
}
(exist_cmd jq 1> /dev/null) || install_jq

function install_yq() {
  echo "INSTALL yq";
  JQ_URL=https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_linux_amd64
  if is_macos; then
    JQ_URL=https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_darwin_arm64
  fi

  mkdir -p tmp
  curl -fSL -o tmp/yq "${JQ_URL}"
  chmod +x tmp/yq
  if is_macos; then
    mv -v tmp/yq /usr/local/bin/yq
    ls -la /usr/local/bin/yq
  fi
  if is_ubuntu; then
    sudo mv -v tmp/yq /usr/bin/yq
    ls -la /usr/bin/yq
  fi
  yq --version
}

(exist_cmd yq) && {
  text_w_color "UPDATE yq? (y/n) > " "Yellow"
  read to_update
  if is_true $to_update; then
    install_yq
  fi
}
(exist_cmd yq 1> /dev/null) || install_yq

wait_for_enter


