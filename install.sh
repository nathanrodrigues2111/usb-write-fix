#!/bin/sh
# Install the udev rule and apply it to USB disks already plugged in.
set -e
cd "$(dirname "$0")"
pkexec sh -c "install -m644 '$PWD/99-usb-writeback.rules' /etc/udev/rules.d/ && udevadm control --reload && udevadm trigger --action=change --subsystem-match=block"
echo "Installed. Replug or already-plugged USB disks are capped at 16 MB of unwritten data."
