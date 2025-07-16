# Setup OS Scripts

This repository contains scripts to automate the setup of various operating systems and configurations.

```curl -fsSL <URL> | bash```

## Linux (Ubuntu/Debian)
- [`linux-01.sh`](https://url.trinitro.io/linux-setup): Sets up Docker and configures Git.
- [`linux-02-cifs-mount.sh`](https://url.trinitro.io/linux-cifs): Mounts external CIFS network drives.
- [`linux-03-bash-aliases.sh`](https://url.trinitro.io/linux-alias): Adds Docker and Docker Compose aliases/functions for easier container management.
- [`linux-04-kernel-changed.sh`](https://url.trinitro.io/linux-kernel): Set a specific Linux kernel version using GRUB.

## Windows
- `windows-01.md`: Step-by-step guide for installing and configuring Windows on bare metal or Proxmox VM.
- [`windows-02.ps1`](https://url.trinitro.io/win-setup): Automates Windows setup: installs software, configures SSH/Git, and restores workspace/configurations.

## MacOS
- `macos-01.md`: Step-by-step guide for installing and configuring macOS on Proxmox.
- [`macos-02.sh`](https://url.trinitro.io/mac-setup): Installs Homebrew, essential packages, and configures user and Git settings.

## Others
- `nas-00.sh`: Creates a symbolic link for Docker data on Synology NAS.
- `pbs-00.sh`: Installs Proxmox Backup Server and provides setup notes for PBS and Proxmox VE integration.
- `kasm-00.sh`: Installs Kasm Workspaces on Ubuntu/Debian.
