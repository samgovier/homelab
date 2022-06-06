# Application Installation Roadmap

## Underlying Infrastructure
Need to decide between:
1. K3s
2. Docker
3. Podman

I like the idea of using the knowledge I now have to run Kubernetes. However, I would love to get manual experience running Containers, to see how the deployment works, see the container, play with it, spin it down, let it run effectively... Kinda feel like I should do both. Deploy and play with containers on my desktop. Deploy to "Production" on my laptop with k3s.

### TEST environment: my desktop
1. Podman in Vagrant in HyperV

### PROD environment: xps13
1. K3s (with Proxmox? Or just plain?)

## Applications On Top
1. Nextcloud (30Gi)
2. Minecraft (30Gi)
    * https://www.reddit.com/r/homelab/comments/d36b8e/minecraft_server_requirements/
3. 