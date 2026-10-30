# usb-write-fix

Two annoying Linux pendrive problems, fixed with one udev rule:

1. **Files vanish after unplug.** You copy files, the copy dialog says done, you pull the
   stick out, plug it back in, and the files are not there.
2. **Stick mounts read-only.** Sometimes the pendrive opens as read-only and you cannot
   copy anything onto it.

## Why it happens

**Files vanish:** Linux does not write to the stick right away. It keeps the data in RAM
(often gigabytes) and writes it out later. Pendrives are slow, so the copy dialog finishes
long before the data is really on the stick. Pull it out at that point and the data is lost.

**Read-only:** pulling a stick out before the write finishes leaves an NTFS drive marked
"dirty". On the next plug-in, Linux sees the mark and mounts the drive read-only to be safe.

## What this does

- Lets Linux hold at most **16 MB** of unwritten data per USB drive. The copy dialog now
  shows the real speed and only finishes when the files are actually on the stick.
- On plug-in, runs `ntfsfix -d` on USB NTFS drives to clear the dirty mark, so they mount
  read-write again.
- Internal disks are not touched. Nothing runs in the background.

## Requirements

- Linux with udev (Ubuntu, Zorin, Mint, Fedora, Debian, Arch, and most others)
- `ntfs-3g` for the read-only fix (`sudo apt install ntfs-3g`, usually already installed)

## Install

```sh
git clone https://github.com/nathanrodrigues2111/usb-write-fix.git
cd usb-write-fix
./install.sh
```

You will get a password prompt. Unplug and replug your USB drives afterwards.

## Check it works

Plug in a pendrive, find its name (for example `sdb`) with `lsblk`, then:

```sh
cat /sys/block/sdb/bdi/max_bytes     # about 16777216
cat /sys/block/sdb/bdi/strict_limit  # 1
```

Copy a big file to the stick. The progress bar should now move at the stick's real speed
instead of jumping to 100 percent.

## Uninstall

```sh
./uninstall.sh
```

## Notes

- **Copies may look slower.** They are not. The old speed was fake, the data was only in RAM.
- **Still click eject before unplugging.** It writes the last few MB and closes the drive cleanly.
- **Still read-only after install?** The stick was probably last used on a Windows PC with
  Fast Startup on. Windows leaves the drive hibernated and Linux will not write to it. Turn
  off Fast Startup in Windows (Control Panel, Power Options, Choose what the power buttons
  do), or shut Windows down with Shift + Shut down.
- **Need a different limit?** Edit `16777216` (bytes) in `99-usb-writeback.rules` and run
  `./install.sh` again.

## License

MIT
