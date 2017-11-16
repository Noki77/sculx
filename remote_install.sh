#!/bin/bash

HAS_GIT=1
if [[ $(command -v git) = "" ]]; then
  HAS_GIT=0
fi

if [[ HAS_GIT = 0 && $(command -v wget) = "" && $(command -v tar) == "" ]]; then
  echo "Please install either git, or wget and tar (preferably git)."
  exit
fi

if [[ HAS_GIT = 1 ]]; then
  git clone https://github.com/Noki77/sculx.git
  cd sculx
  bash install/install.sh
  cd ..
  rm -rf sculx
else
  wget https://api.github.com/repos/Noki77/sculx/tarball/master -O repo.tar.gz
  tar -zxvf repo.tar.gz
  cd Noki77-sculx-*
  bash install/install.sh
  cd ..
  rm -rf Noki77-sculx-*
fi
