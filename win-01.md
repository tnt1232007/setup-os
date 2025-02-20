1. Boot to Windows Installer:
    - Pay attention to the booting
    - May need to modify boot order
    - May need to press a key to boot from CD

2. Installing Windows:
    - Follow the installer steps according to your preferences
    - In Product Key, select `I don't have a product key`
    - In Select Image, select `Pro` version for RDP feature
    - In Disk selection, create Partition according to your preferences
        > For Proxmox, need to install 3 drivers:
        > - Hard disk: `vioscsi\w11\amd64`
        > - Network: `NetKVM\w11\amd64`
        > - Memory Ballooning: `Balloon\w11\amd64`

3. To Skip online Microsoft account:
    - `Shift + F10` to show command prompt
    - `ipconfig /release` > Enter
    - Close command prompt
    - Go back a screen
    - Proceed using local account

5. Login to Windows:
    - Enable RDP
    - Check hostname, IP address, update windows
        > For Proxmox, need to install:
        > - Guest Agent: [`qemu-ga-x86_64.msi`](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-qemu-ga/qemu-ga-x86_64.msi)
        > - Missing drivers: `virtio-win-gt-x64.msi`
    - Restart if needed

6. RDP to Windows:
    - Activate: `irm https://get.activated.win | iex`
    - Setup: `irm https://url.trinitro.io/setup | iex`
        > For Proxmox, need to shutdown and go to Proxmox VE:
        > - Set Options > Use tablet for pointer > No
        > - Detach 2 CD/DVD ISOs
        > - Take a backup/snapshot