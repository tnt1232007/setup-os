apt update && apt dist-upgrade -y

EXTERNAL_MOUNT="//192.168.1.60/external /mnt/external cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | tee /etc/fstab -a
systemctl daemon-reload
mkdir /mnt/external
mount /mnt/external
ls -l /mnt/external

EXTERNAL_MOUNT="//192.168.1.60/media /mnt/media cifs defaults,rw,username=docker,password=3@V<R:3@V<R:,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
echo $EXTERNAL_MOUNT | tee /etc/fstab -a
systemctl daemon-reload
mkdir /mnt/media
mount /mnt/media
ls -l /mnt/media