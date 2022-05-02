#!/bin/bash

set -o pipefail

# Format the disk
mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/nvme1n1

# Mount the disk
mkdir -p /mnt/disks/d1
mount -o discard,defaults /dev/nvme1n1 /mnt/disks/d1
chmod a+w /mnt/disks/d1

# Add automatic mount
FSTAB_ENTRY="UUID=$(blkid -o value -s UUID /dev/nvme1n1) /mnt/disks/d1 ext4 discard,defaults 0 2"
echo "$FSTAB_ENTRY" >> /etc/fstab
