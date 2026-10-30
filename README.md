<div align="center">

# 🔌 usb-write-fix

**Stop losing files on Linux pendrives.**
Real copy progress. No more read-only sticks. One command.

[![License: MIT](https://img.shields.io/badge/license-MIT-22c55e?style=flat-square)](LICENSE)
![Platform](https://img.shields.io/badge/platform-Linux-0ea5e9?style=flat-square&logo=linux&logoColor=white)
![udev](https://img.shields.io/badge/built%20with-udev-a855f7?style=flat-square)
![Size](https://img.shields.io/badge/size-1%20file-f59e0b?style=flat-square)

</div>

---

## 😤 The problem

You copy files to a pendrive. The dialog says **done**. You unplug it, plug it back in, and... **the files are gone.**

Or the stick suddenly shows up as **read-only** and you cannot copy anything onto it.

## 🧠 Why it happens

| Symptom | What is really going on |
| --- | --- |
| **Files vanish** | Linux keeps your copy in RAM (often gigabytes) and writes it to the stick later. Pendrives are slow, so the dialog says done long before the data is actually there. |
| **Read-only stick** | Unplugging mid-write leaves NTFS marked *dirty*. Next time, Linux plays it safe and mounts the drive read-only. |

## ✨ What this fixes

| | Before | After |
| --- | --- | --- |
| Copy progress | Jumps to 100% instantly, fake | Real speed of your stick |
| Data waiting in RAM | Up to several GB | Max **16 MB** per USB drive |
| Unplug after "done" | Files lost | Files are on the stick |
| Dirty NTFS stick | Mounts read-only | Auto-cleaned, mounts read-write |
| Internal disks | | Untouched |
| Background process | | None, pure udev rule |

## 🚀 Install

**One command.** Paste into a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/nathanrodrigues2111/usb-write-fix/master/99-usb-writeback.rules | sudo tee /etc/udev/rules.d/99-usb-writeback.rules >/dev/null && sudo udevadm control --reload && echo Installed
```

<details>
<summary><b>Or clone the repo</b></summary>

```sh
git clone https://github.com/nathanrodrigues2111/usb-write-fix.git
cd usb-write-fix
./install.sh
```

</details>

Then **unplug and replug** your USB drives. That's it. ✅

## 🔍 Check it works

Plug in a pendrive and find its name with `lsblk` (for example `sdb`):

```sh
cat /sys/block/sdb/bdi/max_bytes     # ~16777216
cat /sys/block/sdb/bdi/strict_limit  # 1
```

Copy a big file. The progress bar now moves at your stick's real speed. 🐢 → ✅

## 📋 Requirements

- 🐧 Any Linux with udev: Ubuntu, Zorin, Mint, Fedora, Debian, Arch, Pop!_OS...
- 💾 `ntfs-3g` for the read-only fix (usually preinstalled, else `sudo apt install ntfs-3g`)

## 💡 Good to know

> [!NOTE]
> **Copies look slower now.** They are not. The old speed was fake, the data was only sitting in RAM.

> [!TIP]
> **Still click eject** before unplugging. It flushes the last few MB and closes the drive cleanly.

> [!WARNING]
> **Still read-only?** The stick was likely last used on Windows with **Fast Startup** on, which leaves it hibernated. Turn it off in *Control Panel > Power Options > Choose what the power buttons do*, or hold **Shift** while clicking Shut down.

<details>
<summary><b>⚙️ Change the 16 MB limit</b></summary>

Edit `16777216` (bytes) in `99-usb-writeback.rules`, then run `./install.sh` again.

</details>

## 🗑️ Uninstall

```sh
sudo rm /etc/udev/rules.d/99-usb-writeback.rules && sudo udevadm control --reload
```

Or `./uninstall.sh` from the repo. Replug drives to go back to normal.

## 🛠️ How it works

One udev rule, two lines:

1. On USB disk plug-in, sets `bdi/max_bytes` to 16 MB and turns on `bdi/strict_limit`, so the kernel cannot hoard writes for that drive.
2. On USB NTFS partition plug-in, runs `ntfsfix -d` to clear the dirty flag. It refuses mounted or hibernated volumes, so it is safe.

---

<div align="center">

**MIT licensed.** If this saved your files, drop a ⭐

</div>
