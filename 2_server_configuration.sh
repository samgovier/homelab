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
vim /etc/systemd/logind.conf
#HandleLidSwitch=ignore

# added xps13 as a static IP to my router's DHCP service