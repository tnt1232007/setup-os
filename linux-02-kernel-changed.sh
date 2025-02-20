#!/bin/bash

# Step 1: List installed Linux kernel images
# This helps verify available kernel versions before installation.
apt search linux-image | grep installed

# Step 2: Install the desired Linux kernel
# Change version if needed
apt install -y linux-image-6.1.0-31-amd64

# Step 3: Identify available kernels in GRUB
# This helps determine the correct entry name for setting the default boot kernel.
grep "menuentry '" /boot/grub/grub.cfg

# Step 4: Set the default kernel version in GRUB
# Ensure the correct entry index ("1>2" format) is used, based on the output above.
GRUB_DEFAULT="1>2"
echo "GRUB_DEFAULT=\"$GRUB_DEFAULT\"" >> /etc/default/grub

# Step 5: Update GRUB configuration to apply changes
update-grub

# Step 6: Confirm the selected default kernel
grep "GRUB_DEFAULT" /etc/default/grub

# Step 7: Prompt for reboot to activate the new kernel
echo "Reboot your system for changes to take effect. Run 'uname -r' after reboot to verify."
