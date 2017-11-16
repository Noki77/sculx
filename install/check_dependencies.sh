#!/bin/bash

declare -A PACKAGE_NAME_INDEXES
PACKAGE_NAME_INDEXES[mpg123]=1
PACKAGE_NAME_INDEXES[xclip]=2
PACKAGE_NAME_INDEXES[jq]=3
PACKAGE_NAME_INDEXES[curl]=4
PACKAGE_NAME_INDEXES[notify-send]=5

PACKAGES=("mpg123" "xclip" "jq" "curl" "libnotify")
PACKAGES_DEBIAN=("mpg123" "xclip" "jq" "curl" "libnotify-bin")
#PACKAGES_ARCH=("mpg123" "xclip" "jq" "curl" "libnotify")
#PACKAGES_FEDORA=("mpg123" "xclip" "jq" "curl" "libnotify")
#PACKAGES_REDHAT=("mpg123" "xclip" "jq" "curl" "libnotify")
#PACKAGES_SUSE=("mpg123" "xclip" "jq" "curl" "libnotify")

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
    checkForCommand $command
    if [ "$?" -eq 1 ]; then
      MISSING_DEPS="$MISSING_DEPS $command"
    fi
  done
  echo "$MISSING_DEPS"

  if [[ ! $MISSING_DEPS = "" ]]; then
    return 1
  fi
}

function checkForCommand() {
  command -v "$1" &>/dev/null || {
    return 1
  }
}

function getMissingPackages() {
  pkgs=""
  package_array=("${PACKAGES[@]}")
  if [[ $(getPackageManager) = "apt" ]]; then
    package_array=("${PACKAGES_DEBIAN[@]}")
  fi
# TODO: broken in bash, working in zsh
  for cmd in `checkDependencies`; do
    index=$PACKAGE_NAME_INDEXES[$cmd]
    packageName=$package_array[$index]
    pkgs="$pkgs $packageName"
  done
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
    echo "It seems you are missing the following dependencies:$packages"
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

checkAndInstall
