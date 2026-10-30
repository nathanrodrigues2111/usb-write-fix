# usb-write-fix

Linux caches writes in RAM. Copying to a slow pendrive "finishes" in seconds while
gigabytes still sit in memory. Unplug without ejecting and the files are gone, and an
NTFS drive is left dirty (it may mount read-only next time).

This udev rule caps unwritten data per USB disk at 16 MB (`bdi/max_bytes` +
`bdi/strict_limit`). The copy dialog then shows the real speed and ends when the
data is actually on the stick. Internal disks are untouched.

## Install

    ./install.sh

## Check

    cat /sys/block/sdX/bdi/max_bytes   # 16777216-ish

## Uninstall

    pkexec rm /etc/udev/rules.d/99-usb-writeback.rules

Still press eject before unplugging. It flushes the last 16 MB and cleanly closes NTFS.
If an NTFS stick mounts read-only after a bad unplug: `pkexec ntfsfix -d /dev/sdX1`.
