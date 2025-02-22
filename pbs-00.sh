#!/bin/bash
set -euo pipefail

apt update && apt dist-upgrade -y

echo "📦 Adding repository for Proxmox Backup Server..."
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" >> /etc/apt/sources.list
apt update

echo "📦 Installing Proxmox Backup Server..."
apt install proxmox-backup-server -y

# In pbs
#   - create datastore point to /mnt/data
#   - copy fingerprint in dashboard
# In proxmox
#   - add pbs as storage
#   - create backup schedule