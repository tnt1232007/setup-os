sudo apt update && sudo apt dist-upgrade -y
EXTERNAL_MOUNT="//192.168.1.60/external /mnt/external cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | sudo tee /etc/fstab -a
EXTERNAL_MOUNT="//192.168.1.60/media /mnt/media cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | sudo tee /etc/fstab -a
sudo systemctl daemon-reload
sudo mount /mnt/external
sudo mount /mnt/media