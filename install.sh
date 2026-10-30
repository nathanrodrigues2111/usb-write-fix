#!/bin/sh
# Install the udev rule and apply it to USB disks already plugged in.
set -e
cd "$(dirname "$0")"
ROOT=sudo; command -v pkexec >/dev/null && ROOT=pkexec
command -v ntfsfix >/dev/null || echo "Note: ntfsfix not found, install ntfs-3g for the read-only fix."
$ROOT sh -c "install -m644 '$PWD/99-usb-writeback.rules' /etc/udev/rules.d/ && udevadm control --reload && udevadm trigger --action=change --subsystem-match=block"
echo "Installed. Unplug and replug your USB drives to apply everything."
