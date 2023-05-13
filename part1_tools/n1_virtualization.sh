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
echo -n "UPDATE packages? (y/n) > "
read to_update

if is_true $to_update && [ "$MY_OS" = "linux" ]; then
    sudo aptitude update -y
fi

if is_true $to_update && [ "$MY_OS" = "darwin" ]; then
  (exist_cmd brew) && {
    brew update && brew upgrade
  }
fi

wait_for_enter




