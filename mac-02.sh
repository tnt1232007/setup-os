#!/bin/bash
# bash mac-02.sh
set -euo pipefail

# Install brew and wget
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install wget
brew install --cask parsec

### OPTIONAL - Configure booting without OpenCore mounted

# Download Mount EFI script
cd ~/Downloads/
git clone https://github.com/corpnewt/MountEFI
cd MountEFI/
chmod +x MountEFI.command
./MountEFI.command
# Select 2 (MacOS drive) > Enter
# Select Q (Quit) > Enter

# Download KVM OpenCore EFI folder
cd ~/Downloads/
VM_OPENCORE_EFI_LINK=$(curl --silent -m 10 --connect-timeout 5 "https://api.github.com/repos/thenickdude/KVM-Opencore/releases/latest" | grep /download/ | grep OpenCoreEFIFolder | grep .zip | cut -d'"' -f4)
echo -e "\e[32mDownloading OpenCore EFI folder from $VM_OPENCORE_EFI_LINK...\e[0m"
VM_OPENCORE_EFI=$(wget $VM_OPENCORE_EFI_LINK -nv 2>&1 | cut -d\" -f2)
unzip $VM_OPENCORE_EFI
rm $VM_OPENCORE_EFI

# Copy KVM OpenCore EFI folder to /Volumes/EFI
cd ~/Downloads/
# If an existing EFI folder exists, rename the it to EFI.orig
if [ -d /Volumes/EFI/EFI ]; then
    mv /Volumes/EFI/EFI /Volumes/EFI/EFI.orig
fi
cp -r EFI /Volumes/EFI

# Cleanup
rm -rf EFI
rm -rf MountEFI

# Shutdown
sudo shutdown -h now

# Remove ide0 and ide2 in host
qm set $VM_ID --delete ide0
qm set $VM_ID --delete ide2