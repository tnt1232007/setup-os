#!/bin/bash
# bash kasm.sh 1.16.1 98d6fa
set -euo pipefail

# OS Configuration - INPUT PARAMETERS
OS_VERSION="${1:-1.16.1}"
OS_HASH="${2:-98d6fa}"

# Change root password
echo -e "\e[32mWill prompt for new password, twice...\e[0m"
passwd

# Instal sudo
apt-get update && apt-get upgrade -y
apt-get install sudo -y

# Install kasm
cd /tmp
OS_FILE="kasm_release_$OS_VERSION.$OS_HASH.tar.gz"
wget https://kasm-static-content.s3.amazonaws.com/$OS_FILE
tar -xf $OS_FILE
rm $OS_FILE
yes | ./kasm_release/install.sh