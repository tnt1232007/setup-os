#!/bin/bash
set -euo pipefail

# OS detail
source /etc/os-release
OS_NAME=$ID

# Install docker & docker compose
USER=root
apt-get update && apt dist-upgrade -y
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$OS_NAME/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS_NAME \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
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