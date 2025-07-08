## 1. Booting to Installer
- Select UEFI Shell
- Change to Mac iso `fs0:`
- Launch the installer `System\Library\CoreServices\boot.efi`

## 2. Installing
- Select Disk Utility
- Select Apple Inc. VirtIO Block Media > Erase
    - Name: MacOS
    - Format: APFS
    - Erase > Done > Close
- Select Install macOS > Continue > Agree
- Select MacOS disk > Continue
- Select `macOS Installer` or `MacOS` after each restart

## 3. Setting up
- Follow the setup steps based on preferences
- Skip the Apple ID
- Don't Use Location Services
- Uncheck Share Analytics
- Skip Screen Time

## 4. Configuring 1 - direct
- Enable Remote Login
- Enable Screen Sharing
- Check About > Name, IP address, OS updates

## 5. Configuring 2 - via VNC
- Configure booting without OpenCore mounted: [guide](https://i12bretro.github.io/tutorials/0628.html)
- Setup `wget -qO- https://url.trinitro.io/setupmacos > tmp.sh && chmod +x tmp.sh && ./tmp.sh && rm ./tmp.sh`
