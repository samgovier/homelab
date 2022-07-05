# Pihole Deployment

[PiHole in Kubernetes Medium Post](https://subtlepseudonym.medium.com/pi-hole-on-kubernetes-87fc8cdeeb2e)

[PiHole Helm + Considerations](https://cdcloudlogix.com/pihole-docker-and-kubernetes-simple-guide/)

[Further Configuration Notes](https://www.technicallywizardry.com/pihole-docker-kubernetes/)

Tried to do one shared volume for both directories on the PiHole container but the pod can't do that. You must have two different persistent volumes for the different directories.

I suppose I could have just mounted `/etc/` directly, but that's a very central directory to just mount. I'll create two separate persistent volumes.

Also, found out that ClusterIP can be given an External IP, without having to use NodePort. However... this does require the IP to be set in the config, which I would like to avoid for privacy. My test can use it just for interest but I won't use that in Production.

## Issues with current setup (singular service)
> As I mentioned earlier, we’re using a basic Service definition with an explicitly defined external IP address. The downside to this is that all requests reflected in the pihole dashboard will be forwarded from the kube-dns cluster internal IP address. We still have all the data on where our requests are going, but this keeps us from understanding who’s making the requests. ~[Connor Demille](https://subtlepseudonym.medium.com/pi-hole-on-kubernetes-87fc8cdeeb2e)

Actually now that I think about this more this is a big ol' problem... Especially with my current push preference towards NodePort. I don't have ports configured under 30000 on my prod cluster. I think I may setup a straight up port forward? Will that work? Let's try it.

The port forward on my router is meant for external access and I assume would be accessible from the internet, which I am not ready to expose yet. I'm going to configure a LoadBalancer Service type like I did for Nextcloud. I'm going to keep the ClusterIP config for future reference though, for test.

Well, I tested LoadBalancer service types in Minikube locally to test and turns out it DIDN'T WORK. Looks like K3S handles a loadbalancer service type and assigns it directly to a node IP... perhaps the Control Plane Node. Not totally sure... but for test on Minikube, I guess I'll use an externalIP with a ClusterIP service type. And I can only see the external IP... so yeah makes sense :)

## PiHole DNS learning

This may be useful: [Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)