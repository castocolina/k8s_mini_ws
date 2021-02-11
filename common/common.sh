#!/bin/bash

export SEPARATOR="-- ============================================================================================== --"
export CONSOLE_OUT_SEP_STR=$SEPARATOR
export MY_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
export MY_PLATFORM=$(uname -m)

source /etc/os-release &>/dev/null

function exist_cmd() {
  CMD=$1
  { command -v $CMD >/dev/null 2>&1 && echo "'$CMD' is INSTALLED!" && return_cd=0; } || \
  { echo >&2 "I require '$CMD' but it's not installed."; return_cd=1; }
  # type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  # echo $return_cd;
  return $return_cd;
}

function wait_for_enter() {
  echo -n "ENTER TO CONTINUE!"
  read test_input
}

function is_linux() {
  echo $MY_OS | grep -iqF "linux" && return
  false  
}

function is_macos() {
  echo $MY_OS | grep -iqF "Darwin" && return
  false
}

function is_arch() {
  echo $ID_LIKE | grep -iqF "arch" || echo $ID | grep -iqF "arch" && return
  false
}

function is_ubuntu() {
   echo $ID_LIKE | grep -iqF "ubuntu" || echo $ID | grep -iqF "ubuntu" && return
   false
}

function wait_time(){
	secs=$1
	while [ $secs -gt 0 ]; do
	   echo -ne "    WAIT $secs\033[0K\r"
	   sleep 1
	   : $((secs--))
	done
}
