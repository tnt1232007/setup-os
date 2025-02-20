1. Launch the noVNC console:
    - Start Now
    - Select UEFI Shell > Enter
    - Change to Mac iso `fs0:`
    - Launch the installer `System\Library\CoreServices\boot.efi`

2. In the Mac OS Installer:
    - Select Disk Utility
    - Select Apple Inc. VirtIO Block Media > Erase

3. Inside Erase popup:
    - Name: MacOS
    - Format: APFS
    - Erase > Done > Close

4. Back to the Mac OS Installer:
    - Select Install macOS > Continue x2 > Agree x2
    - Select MacOS disk > Continue
    - Wait for it to restart a couple times, select `macOS Installer` or `MacOS` each restart

5. In the Mac OS Setup:
    - Follow the setup steps based on preferences
    - Skip the Apple ID
    - Don't Use Location Services
    - Uncheck Share Mac Analytics
    - Skip Screen Time

6. In Mac OS:
    - Settings > General > Turn on Remote Login
    - Settings > General > Turn on Screen Sharing

7. Run:
    - `wget -qLO - https://gist.trinitro.io/tnt1232007/setup-os/raw/HEAD/mac-02.sh | bash -s`