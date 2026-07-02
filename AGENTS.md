# AGENTS.md — setup-os

## Communication Style

Terse like caveman. Technical substance exact. Only fluff die.
Drop: articles, filler (just/really/basically), pleasantries, hedging.
Fragments OK. Short synonyms. Code unchanged.
Pattern: [thing] [action] [reason]. [next step].
ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".

---

## Project Overview

OS setup scripts for fresh machines. Curl-installable via short URLs at `url.trinitro.io`.
Owner: Nhan Ngo (`tnt1232007@gmail.com`). Repo: `tnt1232007/setup-os`.

---

## Repository Layout

```
setup-os/
├── linux-01.sh                # Docker CE + Git config + clone docker repo
├── linux-02-cifs-mount.sh     # Mount CIFS/SMB network drives
├── linux-03-bash-aliases.sh   # Docker/Compose aliases + dcuf/dcpf/dcdf functions
├── linux-04-kernel-changed.sh # Pin kernel version via GRUB
├── macos-01.md                # Manual macOS setup guide (Proxmox)
├── macos-02.sh                # Homebrew + packages + Git config
├── windows-01.md              # Manual Windows setup guide (bare metal / Proxmox VM)
├── windows-02.ps1             # Automated Windows setup via winget + PowerShell modules
├── nas-00.sh                  # Synology NAS: symlink docker data volume
├── pbs-00.sh                  # Proxmox Backup Server install + notes
├── kasm-00.sh                 # Kasm Workspaces install on Ubuntu/Debian
└── popos-01.md / popos-02.sh  # Pop!_OS manual guide + setup script
```

---

## Short URLs

| Script | URL |
|--------|-----|
| `linux-01.sh` | `https://url.trinitro.io/linux-setup` |
| `linux-02-cifs-mount.sh` | `https://url.trinitro.io/linux-cifs` |
| `linux-03-bash-aliases.sh` | `https://url.trinitro.io/linux-alias` |
| `linux-04-kernel-changed.sh` | `https://url.trinitro.io/linux-kernel` |
| `windows-02.ps1` | `https://url.trinitro.io/win-setup` |
| `macos-02.sh` | `https://url.trinitro.io/mac-setup` |

---

## Platform Coverage

### Linux (Ubuntu/Debian)
- Run scripts as `root` or via `sudo`.
- `linux-01.sh`: installs Docker CE (official repo), configures Git global user, clones `docker` repo via SSH.
- `linux-03-bash-aliases.sh`: installs key shell functions — `dcuf` (up), `dcdf` (down), `dcpf` (pull), `dcrf` (restart).
- CIFS mount targets Synology NAS network shares.

### Windows
- `windows-02.ps1` must run as Administrator.
- Uses `winget` for software install, `PowerShell` modules (`posh-git`, `PSReadLine`, `Recycle`).
- Installs: PowerShell 7, AutoHotkey, Raycast, PowerToys, Bitwarden, Chrome, StartAllBack, Everything.
- Optional: entertainment (Plex, Spotify, Steam, MPC-HC), programming (JetBrains, DotNet, NVM, Yarn).
- Configures network drive mounts using `NETWORK_DRIVE_USERNAME` / `NETWORK_DRIVE_PASSWORD`.

### macOS
- `macos-02.sh`: Homebrew install + packages + Git config.
- `macos-01.md`: manual steps for macOS on Proxmox (OSX-KVM).

### NAS / PBS / Kasm
- `nas-00.sh`: single symlink for Docker data on Synology (`/volumeUSB1/usbshare/docker/ → /mnt/docker`).
- `pbs-00.sh`: Proxmox Backup Server setup.
- `kasm-00.sh`: Kasm Workspaces on Ubuntu/Debian.

---

## Key Shell Functions (`linux-03-bash-aliases.sh`)

| Function | Purpose |
|----------|---------|
| `dcuf [name]` | `docker compose up -d` + poll Traefik proxy until ready (60s timeout) |
| `dcdf [name]` | `docker compose down -t 120` |
| `dcpf [name]` | `docker compose pull` |
| `dcrf [name]` | restart service |
| `pls` | re-run last command with `sudo` |

`SESSION_DOCKER_NAME` env var used as fallback name in all functions.

Traefik proxy check uses:
- `proxy.trinitro.io` (host `lxc-gpu`)
- `proxy-<HOSTNAME>.trinitro.io` (other hosts)

---

## Agent Notes

- `.md` files are manual guides, not runnable scripts.
- All Linux scripts use `set -euo pipefail` (strict mode).
- Windows script requires PowerShell 5+ to bootstrap, then installs PS7.
- `linux-01.sh` clones the `docker` repo via SSH — SSH key must be pre-configured on the target machine.
- Short URLs are managed externally at `url.trinitro.io` (Kutt instance).
