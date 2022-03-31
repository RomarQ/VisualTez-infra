## Enlarge partition after resize

```sh
# Check which partition to enlarge
lsblk
# Enlarge partition
sudo resize2fs /dev/sdb
```
