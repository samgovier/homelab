# homelab
Open-source, multipurpose repository to document my journey bringing up my homelab environment.

For now, I'm going to start right here. Further scripting and commands will be contained in stepwise files.

## Next Steps
* Common
  * Backups (hardware, k3s, native)
  * Restore Process
  * 3 copies: Prod, Backblaze B2, (Macbook, or backup server?)
  * 2 media types: cloud and HDD (don’t do SSD…)
  * 1 copy offsite: Backblaze B2
* Next steps for Homelab
  * PiHole testing
  * PiHole PROD
  * PiHole connect @ phone first
  * PiHole secret
  * PiHole Helm Articles
  * Kustomize on PiHole


## Overall Plan
Below is my current overall plan for complete deployment:
1. Starting the process with my POC server: a leftover XPS 13 laptop, hardware from 2017 (9360).
etc.

## Dell XPS 13 9360

### Specifications
[Can be found here](https://dl.dell.com/topicspdf/xps-13-9360-laptop_setup-guide_en-us.pdf)
* 7th generation Intel Core i3, 4GB RAM, 128 GB SSD

### BIOS Settings Changed from Default
1. Peak Shift to make sure no AC power is used during the day, and battery is used instead
2. Primary Battery Charge Configuration to set Primary AC Use, Battery lifespan is extended for users who are using only AC primarily
3. Perform Data Wipe to remove all old data

### Installation Process
1. Tried doing Debian first but had issues getting Wi-Fi connectivity functional to my home network. The specs say that only Ubuntu is supported... I'll give that a shot now.


## Testing stuff

### VMs
1. Vagrant (@ anything)
2. Multipass (@ Ubuntu)

### Kubernetes
1. k3s
2. minikube

### Containers
1. Podman (on Vagrant or Multipass)
2. Docker


## Etc

* [Interesting Notes](https://hyperionlocal.net/?s=How+to+Homelab)
* [Useful network debugging](https://github.com/Praqma/Network-MultiTool)
* [ip tool](https://www.geeksforgeeks.org/ip-command-in-linux-with-examples/)
