#!/bin/bash
if (set -o 2>/dev/null | grep -q pipefail); then
    set -euo pipefail
else
    set -eu
fi

apt update && apt dist-upgrade -y

USERNAME="docker"
PASSWORD="${CIFS_PASS:-}"
if [[ -z "$PASSWORD" ]]; then
	echo "❌ CIFS_PASS environment variable not set." >&2
	exit 1
fi

cred_file="/root/.smb-${USERNAME}"
if [[ ! -f "$cred_file" ]]; then
	umask 077
	cat > "$cred_file" <<EOF
username=$USERNAME
password=$PASSWORD
EOF
fi

add_mount() {
	local share="$1" mount_point="$2"
	mkdir -p "$mount_point"
	local entry="//$share $mount_point cifs credentials=$cred_file,uid=1000,gid=1000,iocharset=utf8,vers=3.0,noauto,x-systemd.automount 0 0"
	if ! grep -q "^//$share[[:space:]]" /etc/fstab; then
		echo "$entry" | tee -a /etc/fstab
	else
		echo "ℹ️  Entry for //$share already exists in /etc/fstab"
	fi
	systemctl daemon-reload
	mount "$mount_point" || echo "⚠️  Could not mount $mount_point immediately; it may automount on access."
	ls -ld "$mount_point"
}

add_mount 192.168.1.60/external /mnt/external
add_mount 192.168.1.60/media /mnt/media