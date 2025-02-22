sudo apt update && sudo apt dist-upgrade -y
EXTERNAL_MOUNT="//192.168.1.60/external/docker /mnt/docker cifs defaults,rw,username=wsl,password=y*bfFNy*bfFN,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | sudo tee /etc/fstab -a
sudo systemctl daemon-reload
# Checked if external drive turned on, then remount
if mountpoint -q /mnt/docker; then
    sudo umount /mnt/docker
fi
sudo mount /mnt/docker