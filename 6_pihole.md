# Pihole Deployment

[PiHole in Kubernetes Medium Post](https://subtlepseudonym.medium.com/pi-hole-on-kubernetes-87fc8cdeeb2e)

[PiHole Helm + Considerations](https://cdcloudlogix.com/pihole-docker-and-kubernetes-simple-guide/)

[Further Configuration Notes](https://www.technicallywizardry.com/pihole-docker-kubernetes/)

Tried to do one shared volume for both directories on the PiHole container but the pod can't do that. You must have two different persistent volumes for the different directories.

I suppose I could have just mounted `/etc/` directly, but that's a very central directory to just mount. I'll create two separate persistent volumes.

Also, found out that ClusterIP can be given an External IP, without having to use NodePort. However... this does require the IP to be set in the config, which I would like to avoid for privacy. My test can use it just for interest but I won't use that in Production.