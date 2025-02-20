# Setup OS Scripts

This repository contains scripts to automate the setup of various operating systems and configurations.

## Linux (Ubuntu/Debian)
### linux-01.sh

This script sets up a Linux environment with Docker, mounts an external drive, and configures Git and aliases.

#### USAGE
```bash
bash linux-01.sh
```

## Windows
### win-01.md

This markdown file provides step-by-step instructions for installing and configuring Windows on bare metal or Proxmox VM.

### win-02.ps1

This script sets up a Windows environment with various software installations and configurations.

#### USAGE
```powershell
Invoke-Expression win-02.ps1
```

## MacOS
### mac-01.md

This markdown file provides step-by-step instructions for installing and configuring macOS on Proxmox.

### mac-02.sh

This script installs Homebrew, wget, and Parsec on macOS, and configures booting without OpenCore mounted.

#### USAGE
```bash
bash mac-02.sh
```
