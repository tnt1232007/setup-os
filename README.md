# Setup OS Scripts

This repository contains scripts to automate the setup of various operating systems and configurations.

## Linux (Ubuntu/Debian)
- `linux-01.sh`: Sets up Docker, mounts drives, and configures Git and aliases.
- `linux-02-bash-aliases.sh`: Adds Docker and Docker Compose aliases/functions for easier container management.
- `linux-03-kernel-changed.sh`: Helps list, install, and set a specific Linux kernel version using GRUB.

## Windows
- `windows-01.md`: Step-by-step guide for installing and configuring Windows on bare metal or Proxmox VM.
- `windows-02.ps1`: Automates Windows setup: installs software, configures SSH/Git, and restores workspace/configurations.

## MacOS
- `macos-01.md`: Step-by-step guide for installing and configuring macOS on Proxmox.
- `macos-02.sh`: Installs Homebrew, essential packages, and configures user and Git settings.

## Others
- `nas-00.sh`: Creates a symbolic link for Docker data on Synology NAS.
- `wsl-00.sh`: Mounts an external network drive in WSL and keeps it available.
- `pbs-00.sh`: Installs Proxmox Backup Server and provides setup notes for PBS and Proxmox VE integration.
- `kasm-00.sh`: Installs Kasm Workspaces on Ubuntu/Debian.