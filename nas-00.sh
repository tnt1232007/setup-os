#!/bin/bash
if (set -o 2>/dev/null | grep -q pipefail); then
    set -euo pipefail
else
    set -eu
fi

sudo ln -s /volumeUSB1/usbshare/docker/ /mnt/docker