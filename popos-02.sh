#!/bin/bash
set -euo pipefail

# OS detail
source /etc/os-release
OS_VERSION=$VERSION_ID
sudo hostnamectl set-hostname vm-popos-${OS_VERSION} # major version only
reboot

# Setup remote access
# TODO: no way to remote access Wayland desktop yet