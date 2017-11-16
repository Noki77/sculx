#!/bin/bash

pwd=$(pwd)
repoPath="."
if [[ $pwd == *"/install" ]]; then
  repoPath=".."
fi

source "$repoPath/install/check_dependencies.sh"
checkAndInstall

function readOption() {
  read answer
  if [[ ! $1 == *"answer"* ]]; then
    echo "Please answer with one of these: $1"
    readOption "$1"
  else
    echo $answer
  fi
}

echo "Install system wide, or only for this user?"
echo "1 system wide"
echo "2 this user"
echo -n "(1/2): "

SUDO="sudo"
CONFIG_FOLDER="/etc/sculx"
SCRIPT_FOLDER="/usr/sbin"
if [[ $(readOption "1/2") -eq 2 ]]; then
  SUDO=""
  CONFIG_FOLDER="$HOME/.local/bin/sculx"
  SCRIPT_FOLDER="$HOME/.local/bin"

  if [[ ! $PATH == *"$HOME/.local/bin"* ]]; then
    cmd="export PATH=$PATH:$HOME/.local/bin"
    echo "\n$cmd" >> $HOME/.profile
    eval "$cmd"

    echo "Added '$HOME/.local/bin' to \$PATH (file: $HOME/.profile)."
  fi
fi

echo "Creating required directories"
$SUDO mkdir -p $CONFIG_FOLDER
$SUDO mkdir -p $SCRIPT_FOLDER

echo "Installing scripts"
$SUDO cp -f $repoPath/bin/* $SCRIPT_FOLDER/

echo "Copying default configurations"
$SUDO cp -rf $repoPath/conf/* $CONFIG_FOLDER/

echo "Configurations stored to $CONFIG_FOLDER, feel free to modify them."
