#!/bin/bash
set -euo pipefail

# OS detail
source /etc/os-release
OS_NAME=$ID

# Install docker & docker compose
USER=root
sudo apt-get update && sudo apt dist-upgrade -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/$OS_NAME/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS_NAME \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo gpasswd -a $USER docker

# Mount external drive
sudo apt update && sudo apt dist-upgrade -y
EXTERNAL_MOUNT="//192.168.1.60/external /mnt/external cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | sudo tee /etc/fstab -a
EXTERNAL_MOUNT="//192.168.1.60/media /mnt/media cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | sudo tee /etc/fstab -a
sudo systemctl daemon-reload
sudo mount /mnt/external
sudo mount /mnt/media

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
cd docker
./git-sparse-checkout-init.sh