#!/bin/bash

declare -A COMMAND_PKGS
COMMAND_PKGS[mpg123]="mpg123"
COMMAND_PKGS[xclip]="xclip"
COMMAND_PKGS[jq]="jq"
COMMAND_PKGS[curl]="curl"
COMMAND_PKGS[notify-send]="libnotify"

declare -A COMMAND_PKGS_DEB
COMMAND_PKGS_DEB[mpg123]="mpg123"
COMMAND_PKGS_DEB[xclip]="xclip"
COMMAND_PKGS_DEB[jq]="jq"
COMMAND_PKGS_DEB[curl]="curl"
COMMAND_PKGS_DEB[notify-send]="libnotify-bin"


REQUIRED_COMMANDS=("mpg123" "xclip" "jq" "curl" "notify-send")

PACKAGE_MANAGERS=("pacman" "apt" "zypper" "dnf" "yum")

function getPackageManager() {
  for man in "${PACKAGE_MANAGERS[@]}"; do
    if [[ ! $(command -v $man) = "" ]]; then
      echo $man
      return
    fi
  done
}

function checkDependencies() {
  MISSING_DEPS=""
  for command in "${REQUIRED_COMMANDS[@]}"; do
	command -v "$command" &>/dev/null || {
      MISSING_DEPS="$MISSING_DEPS $command"
    }
  done
  MISSING_DEPS=$(echo $MISSING_DEPS | sed -e 's/^[[:space:]]*//')
  echo "$MISSING_DEPS"

  if [[ ! $MISSING_DEPS = "" ]]; then
    return 1
  fi
}

function getMissingPackages() {
  pkgs=""
  isDeb=false
  if [[ $(getPackageManager) = "apt" ]]; then
    isDeb=true
  fi

  for cmd in `checkDependencies`; do
		if [ isDeb ]; then		
    	packageName=${COMMAND_PKGS_DEB[$cmd]}
		else
		  packageName=${COMMAND_PKGS[$cmd]}
		fi
    pkgs="$pkgs $packageName"
  done
  pkgs=$(echo $pkgs | sed -e 's/^[[:space:]]*//')
  echo $pkgs

  if [[ ! $pkgs = "" ]]; then
    return 1
  fi
}

function readBool() {
  while true; do
    read answer
    case $answer in
      [Yy]* ) echo 1; break;;
      [Nn]* ) echo 0; break;;
      * ) echo "Please answer one of y/n/yes/no";;
    esac
  done
}

function checkAndInstall() {
  package_manager=$(getPackageManager)
  packages=$(getMissingPackages)

  if [[ "$?" = 1 ]]; then
    echo "It seems you are missing the following dependencies: $packages"
    echo -n "Should I install them for you (y/n)? "
    if [[ $(readBool) -eq 1 ]]; then
      case $package_manager in
        apt ) eval "sudo apt install -y$packages";;
        pacman ) eval "sudo pacman -S$packages --needed --noconfirm";;
        zypper ) eval "sudo zypper in$packages";;
        dnf ) eval "sudo dnf install -y$packages";;
        yum ) eval "sudo yum install -y$packages";;
        * ) echo "Sorry, you're package manager is not supported yet.";;
      esac
    fi
  else
    echo "No dependencies missing."
  fi
}

