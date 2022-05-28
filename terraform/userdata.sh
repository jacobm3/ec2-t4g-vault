#!/bin/bash

hostnamectl set-hostname vault

export DEBIAN_FRONTEND=noninteractive

# add hashi stuff
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

apt-get update
apt-get upgrade -y
apt-get install -y \
  bzip2 \
  git \
  htop \
  iotop \
  jq \
  net-tools \
  netcat \
  nmap \
  python3-pip \
  sysstat \
  tree \
  unzip \
  vault \
  vim-nox 

pip install --upgrade pip
pip install -q boto3 hvac bpytop


# add environment
HM=/home/ubuntu
cd $HM
git clone https://github.com/jacobm3/gbin.git
chmod +x gbin/*

echo '. ~/gbin/jacobrc'  >> ${HM}/.bashrc
ln -s gbin/jacobrc .jacobrc

sudo chown -R ubuntu:ubuntu $HM

cd ${HM}/gbin && sudo cp pg ng /usr/local/bin

./vim.sh 
