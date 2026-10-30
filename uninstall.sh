#!/bin/sh
# Remove the udev rule. Limits on drives already plugged in clear on replug.
set -e
ROOT=sudo; command -v pkexec >/dev/null && ROOT=pkexec
$ROOT sh -c "rm -f /etc/udev/rules.d/99-usb-writeback.rules && udevadm control --reload"
echo "Removed. Replug USB drives to go back to normal."
