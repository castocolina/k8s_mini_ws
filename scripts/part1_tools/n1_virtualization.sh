#!/bin/bash

BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

# https://minikube.sigs.k8s.io/docs/drivers/

source $BASEDIR/../commons/common.sh
source $BASEDIR/../commons/colors.sh

echo
echo BEFORE BEGIN
text_w_color "PLEASE UPDATE YOUR PACKAGE MANAGER INDEXES!!!!\n"
text_w_color "Arch/Manjaro: sudo pacman -Syyu\n" "Red"
text_w_color "Ubuntu: sudo aptitude update -y\n" "Red"
text_w_color "Mac-OS: brew update && brew upgrade\n" "Red"
wait_for_enter

echo
text_w_color "UPDATE packages? (y/n) > " "Yellow"
read to_update

if is_true $to_update && [ "$MY_OS" = "linux" ]; then
    sudo aptitude update -y
fi

if is_true $to_update && [ "$MY_OS" = "darwin" ]; then
  (exist_cmd brew) && {
    brew update && brew upgrade
  }
fi

function install_hyperkit () {
  echo "INSTALL/UPDATE HYPERKIT";
  curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-hyperkit \
  && chmod +x docker-machine-driver-hyperkit \
  && sudo mv docker-machine-driver-hyperkit /usr/local/bin/ \
  && sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit \
  && sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit
}

if is_macos; then
  if [ exist_cmd "docker-machine-driver-hyperkit" ]; then
    text_w_color "UPDATE hyperkit? (y/n) > " "Yellow"
    read to_update
    if is_true $to_update; then
      install_hyperkit;
    fi
  else 
    text_w_color "INSTALL hyperkit? (y/n) > " "Yellow"
    read to_update
    if is_true $to_update; then
      install_hyperkit;
    fi
  fi
fi

function install_kvm2_ubuntu () {
  echo "INSTALL/UPDATE driver-kvm2";
  echo

  clear
  text_w_color "Check KVM" "Blue"
  echo
  lsmod | grep kvm || \
    { 
      >&2 echo "KVM is not supported. https://minikube.sigs.k8s.io/docs/drivers/kvm2/" \
      && return 1; 
    }
  LC_ALL=C lscpu | grep Virtualization
  kvm-ok 
  echo "To use VM drivers, verify that your system has virtualization support enabled"
  egrep -q 'vmx|svm' /proc/cpuinfo && echo yes || echo "Check at https://minikube.sigs.k8s.io/docs/drivers/kvm2/"
  echo

  echo ""
  wait_for_enter

  ## install kvm2 driver
  # curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && \
  # sudo install docker-machine-driver-kvm2 /usr/local/bin/
  # rm -rfv docker-machine-driver-kvm2
  
  sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
  echo 
  virt-host-validate
  text_w_color "Check VIRT Info above\n" "Yellow"
}

if is_ubuntu; then
  if [ -f /dev/kvm ]; then
    text_w_color "UPDATE kvm2? (y/n) > " "Yellow"
    read to_update
    if is_true $to_update; then
      install_kvm2_ubuntu;
    fi
  else 
    text_w_color "INSTALL kvm2? (y/n) > " "Yellow"
    read to_update
    if is_true $to_update; then
      install_kvm2_ubuntu;
    fi
  fi
fi

wait_for_enter


