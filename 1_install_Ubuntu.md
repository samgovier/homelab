# Install Ubuntu

## Decision process
Before starting this process, I attempted to install Debian to this laptop. The installation process was successful, but getting WiFi firmware up and running wasn't getting me anywhere: I was able to get the WiFi interface working but not able to successfully connect to my WiFi router. Unfortunately, because of my current setup, a WiFi connection is required.

It appears that Ubuntu drivers and configuration is much easier than Debian, especially when it comes to newer systems and firmware/drivers, so that is my next option for installation and testing. I wanted to stay in the Debian ecosystem since it's tools are what I'm most used to.

## Download & Flash

__Version__: Ubuntu 22.04 LTS

Using these processes:
* https://ubuntu.com/tutorials/install-ubuntu-server
* https://ubuntu.com/tutorials/install-ubuntu-desktop#3-create-a-bootable-usb-stick

1. Download Ubuntu off [the Canonical website](https://ubuntu.com/download/server) (select option 2).
1. Verify the install matches the expected ISO checksum:
```bash
cd Downloads
echo "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f *ubuntu-22.04-live-server-amd64.iso" | shasum -a 256 --check
# ubuntu-22.04-live-server-amd64.iso: OK
```
1. Download and install [balenaEtcher](https://www.balena.io/etcher/) for flashing
1. Flash the Ubuntu ISO image to wipeable USB drive
1. Plug my wiped XPS 13 laptop into AC power and ethernet for installation processing
1. Insert into my wiped XPS 13 laptop and start the install process!

## Ubuntu Installation steps

1. Using the very nice Ubuntu interface for installing Ubuntu server!
1. Configuration options:
    * Full ubuntu server (not minimal)
    * Wifi packages installed
    * Default mirror
    * Using the entire 128 GB disk, and setting up LVM
        * /boot and /boot/efi get their own partitions
        * Looks like the starting LVG for `/` is ~60 GB? About half of what's leftover? This is fine, maybe I can make some changes as needed by the server purpose
        * Installed OpenSSH for remote access
1. Wait for installation to finish and reboot