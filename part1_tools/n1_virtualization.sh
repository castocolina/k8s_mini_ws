#!/bin/bash

BASEDIR=$(dirname "$0")
sudo echo "Test sudo"

source $BASEDIR/../common/common.sh

echo
echo BEFORE BEGIN
echo "PLEASE UPDATE YOUR PACKAGE MANAGER INDEXES!!!!"
echo "Arch/Manjaro: sudo pacman -Syyu"
echo "Ubuntu: sudo aptitude update -y"
echo "Mac-OS: brew update && brew upgrade"
wait_for_enter
echo

if is_macos; then
  (exist_cmd docker-machine-driver-hyperkit) || {
    echo "INSTALL HYPERKIT";
    curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-hyperkit \
    && chmod +x docker-machine-driver-hyperkit \
    && sudo mv docker-machine-driver-hyperkit /usr/local/bin/ \
    && sudo chown root:wheel /usr/local/bin/docker-machine-driver-hyperkit \
    && sudo chmod u+s /usr/local/bin/docker-machine-driver-hyperkit
  }
fi

if is_linux; then
  (exist_cmd docker-machine) || {
    echo "INSTALL DOCKER MACHINE";
    echo

    echo Check KVM
    lsmod | grep kvm || { >&2 echo "KVM is not supported" && exit 1; }
    LC_ALL=C lscpu | grep Virtualization

    echo


    if is_arch; then
        echo "It is archo/Manjaro family distro"
        sudo pacman -S virt-manager libvirt qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat firewalld
        echo 

        echo CONFIGURE KVM
        sudo usermod -a -G libvirt $(whoami)
        sudo systemctl start libvirtd.service
        sudo systemctl enable libvirtd.service
        sudo systemctl start virtlogd.service
        sudo systemctl enable virtlogd.service
    fi

    if is_ubuntu; then
        echo "It is Ubuntu / kubuntu or mint family distro"
        sudo apt install ebtables dnsmasq firewalld -y
        sudo systemctl restart libvirtd
    fi

    base=https://github.com/docker/machine/releases/download/v0.16.0 &&
    curl -L "$base/docker-machine-${MY_OS}-${MY_PLATFORM} >/tmp/docker-machine" &&
    sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
    chmod +x /usr/local/bin/docker-machine

  }
fi

if is_linux; then
  (exist_cmd docker-machine-driver-kvm2) || {
    echo "docker-machine-driver-kvm2";
    echo

    ## install kvm2 driver
    curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && \
    sudo install docker-machine-driver-kvm2 /usr/local/bin/
    rm -rf docker-machine-driver-kvm2
  }
fi


