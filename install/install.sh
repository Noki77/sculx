#!/bin/bash

pwd=$(pwd)
repoPath="."
if [[ $pwd == *"/install" ]]; then
    repoPath=".."
fi

source "$repoPath/install/check_dependencies.sh"
checkAndInstall

function readOption() {
    while true; do
        read answer
        if [[ "$1" == *"$answer"* ]]; then
            echo $answer
            break;
        fi
    done
}

echo -e "\nInstall system wide, or for this user only?"
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
        cmd="export PATH=\$PATH:$HOME/.local/bin"
        echo -e "\n$cmd" >> $HOME/.profile
        eval "$cmd"

        echo "Added '$HOME/.local/bin' to \$PATH (file: $HOME/.profile)."
    fi
fi

echo "Creating required directories"
$SUDO mkdir -p $CONFIG_FOLDER
$SUDO mkdir -p $SCRIPT_FOLDER

echo "Updating configuration paths"
SED_F_PATH=${CONFIG_FOLDER//\//\\\/}
sed -i "s/SCULX_CONFIG_DIR=\"\/etc\/sculx\"/SCULX_CONFIG_DIR=\"$SED_F_PATH\"/g" $repoPath/bin/*

echo "Installing scripts"
$SUDO cp -f $repoPath/bin/* $SCRIPT_FOLDER/

echo "Copying default configurations"
$SUDO cp -rf $repoPath/conf/* $CONFIG_FOLDER/

echo "Copying resources"
$SUDO cp -rf $repoPath/res $CONFIG_FOLDER/

echo "Configurations stored to $CONFIG_FOLDER, feel free to modify them."
