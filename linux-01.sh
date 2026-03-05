#!/bin/bash
set -euo pipefail

# OS detail
source /etc/os-release
OS_NAME=$ID

# Install docker & docker compose
USER=root
# Add Docker's official GPG key:
apt update
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
gpasswd -a $USER docker

# Git setup
NAME="Nhan Ngo"
EMAIL="tnt1232007@gmail.com"
git config --global user.name $NAME
git config --global user.email $EMAIL
git config --global rebase.autostash true
git config --global pull.rebase true
git config --list --global

# Git clone
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone git@github.com:tnt1232007/docker.git