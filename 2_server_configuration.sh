sudo -s
apt install sudo man curl vim git ssh
# all installed but ssh, and I'm just going to skip that since I don't need the client really

# I attempted the wifi setup that I did with Debian and it also didn't work here.
# Links:
## https://linuxconfig.org/how-to-connect-to-wifi-from-the-cli-on-debian-10-buster
## https://www.matthewcantelon.ca/blog/debian-buster-wifi/
wpa_passphrase wifi_network_name network_password > /etc/wpa_supplicant.conf
vim /etc/wpa_supplicant.conf # configure a bunch of router settings
systemctl restart wpa_supplicant
ip a
wpa_supplicant -B -c/etc/wpa_supplicant.conf -iwlp58s0
wpa_supplicant -c /etc/wpa_supplicant.conf -i wlp58s0
rm /etc/wpa_supplicant.conf

# Okay, we're going to try to use Network Manager instead:
## https://xkema.github.io/2020/enabling-wifi-connection-on-ubuntu-server-20-04-1-lts
vim /etc/netplan/00-installer-config.yaml
# use DEFAULT RENDERER, dhcp4 to true, and set the wifi network name and password
netplan generate
netplan apply
netplan try
# Errored with Network Manager... but using the default I was able to finally get a connection! I guess Netplan (from Canonical) worked fine without it.
## https://netplan.io/

# spotty SSH connection, but it worked!!! I think I need better DNS
ssh user@1.2.3.4


# to keep the computer running with the lid closed
## https://www.dwarmstrong.org/laptop-home-server/
vim /etc/systemd/logind.conf
#HandleLidSwitch=ignore

# Turning off the screen as it's not needed was a hassle. The following commands were done but not needed... probably still some extraneous programs from them
apt install vbetool
apt remove vbetool
apt install x11-xserver-utils
apt remove x11-xserver-utils

# Eventually got it done with comments using setterm in this post:
## https://askubuntu.com/questions/62858/turn-off-monitor-using-command-line
# Remote (didn't work): TERM=linux setterm --blank 1 <> /dev/tty1
setterm --blank 1 --powerdown 1
# Maybe need to investigate this more later...

# OKAY FINALLY. It appears 22.04 is too new, and some typical methods don't work. `setterm` worked though.
# Beyond that, I used the same forum post to configure an auto-start service.

vim /home/govier/screen-off.sh

# #!/bin/bash
# setterm --blank 1 --powerdown 1

vim /etc/systemd/system/screen-off.service

# [Unit]
# Description=Screen turned off after 1 minute. Any keypress will bring it back up.
# After=ssh.service

# [Service]
# Type=oneshot
# Environment=TERM=linux
# StandardOutput=tty
# TTYPath=/dev/tty1
# ExecStart=/home/govier/screen-off.sh

# [Install]
# WantedBy=multi-user.target

sudo chmod +x /home/govier/screen-off.sh
sudo chmod +x /etc/systemd/system/screen-off.service

sudo systemctl start screen-off.service
sudo systemctl enable screen-off.service

# added xps13 as a static IP to my router's DHCP service

# LEARNED FOUR THINGS
## On a router, it's often better to search based on MAC address. You sometimes get random names in the router's list of clients.
## Stop making changes to the router during a work day... It will cut connections on a whim -.-
## Linux can have little variability between distros, eg. Debian vs. Ubuntu. ie, when searching online, try both :)
## Linux can have MUCH variability between versions. So maybe having the newest version was a bad idea.