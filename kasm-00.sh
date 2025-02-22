#!/bin/bash
set -euo pipefail

echo "📦 Updating system..."
apt update && apt dist-upgrade -y
apt install sudo -y

echo "📦 Installing Kasm..."
cd /tmp
LATEST_VERSION_FILE=$(wget -qO- https://kasm-static-content.s3.amazonaws.com | grep -Eo 'kasm_release_[0-9]+\.[0-9]+\.[0-9]+\.[a-zA-Z0-9_]+\.tar\.gz' | sort -V | tail -n 1)
wget https://kasm-static-content.s3.amazonaws.com/$LATEST_VERSION_FILE
tar -xf $LATEST_VERSION_FILE
rm $LATEST_VERSION_FILE
echo "y" | ./kasm_release/install.sh