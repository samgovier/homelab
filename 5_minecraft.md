# Minecraft Deployment

## Test Deployment: using Minikube

[Install Helm Locally](https://helm.sh/docs/intro/install/)

[Helm Usage Notes](https://helm.sh/docs/intro/using_helm/)

[Minecraft Server Charts](https://github.com/itzg/minecraft-server-charts)

[Paper server settings](https://github.com/itzg/docker-minecraft-server/blob/master/README.md#running-a-paper-server)

[useful howto](https://github.com/solarhess/kubernetes-minecraft-server)

## Test deployment: using minikube

Using the howto for now: looks like an older version of the helm chart, so I'll use the bigger better one for Production deploy

```sh
helm repo add itzg https://itzg.github.io/minecraft-server-charts/

minikube ssh
sudo mkdir -p "/mnt/vda1/minecraft"
sudo chmod 777 "/mnt/vda1/minecraft"
ip a
```

Edited `values.yaml` to include the server IP and port 30565.

Back on my local machine:
```sh
cd kubernetes-minecraft-server
helm install minecraft helm/minecraft --namespace minecraft --create-namespace
# Seemed to work properly!
```

Next is to install Minecraft and connect... but I'm getting a Persistent Volume error :( Maybe I'll use the newer one on Minikube instead

## Test Deployment TWO: using Remote Helm chart

itzg repo already added to helm above: `helm repo add itzg <ghlink>`

```sh
helm search repo
helm show values itzg/minecraft > values.yaml
```

Editing default values:
* Accept EULA
* Trying PaperMC
* MOTD is... something
* I kept the default persistence settings at default, but I will configure and test this
* RCON would probably be good for backups. Not going to worry about that right now

With the config setup, let's try a deploy

```sh
helm install -f values.yaml esk-test itzg/minecraft

# NAME: esk-test
# LAST DEPLOYED: Mon Jun 13 16:27:18 2022
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
# NOTES:
# Get the IP address of your Minecraft server by running these commands in the
# same shell:
#   export POD_NAME=$(kubectl get pods \
#     --namespace default \
#     -l "component=esk-test-minecraft" \
#     -o jsonpath="{.items[0].metadata.name}")
#   kubectl port-forward $POD_NAME 25565:25565
#   echo "Point your Minecraft client at 127.0.0.1:25565"

# ############################################################################
# ###   WARNING: Persistence is disabled!!! You will lose your game state  ###
# ###                when the Minecraft pod is terminated.                 ###
# ###      See values.yaml's persistence.dataDir.enabled directive.        ###
# ############################################################################

helm uninstall esk-test
```

No namespace :( Need that for Production. Otherwise looking pretty good

Now to try actually connecting from a minecraft instance:

```sh
helm install -f values.yaml connect-test itzg/minecraft --namespace minecraft --create-namespace

  export POD_NAME=$(kubectl get pods \
    --namespace default \
    -l "component=connect-test-minecraft" \
    -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward $POD_NAME 25565:25565
  echo "Point your Minecraft client at 127.0.0.1:25565"

helm uninstall connect-test -n minecraft
```

Alright, so this is great but keeping a port-forward open is less than ideal. Although maybe I could just open it up to play. Hmm.

This seems like it could get pretty complicated.

Okay I found [a recommendation on GitHub to use NodePort.](https://github.com/itzg/minecraft-server-charts/issues/18) Let's try and pull that off. Modified `values.yaml`.

```sh
helm install -f values.yaml connect-test itzg/minecraft --namespace minecraft --create-namespace
helm uninstall connect-test -n minecraft
```

~~Still no dice. A load balancer IP would probably work, but I'm curious what the recommendation is from the creator.~~

USEFUL TRICK, though: if you need to get into a port that's not just a bash shell in the container, you can port-forward whatever you need, eg: `kubectl port-forward podname localport:targetport -n namespace`

Using this trick we can just do a basic test, `test-netconnection <IP> -port <port>` in Powershell. In Linux, `telnet`, `nmap`, `timeout`...

The above configuration with a `NodePort` actually DID work, but I didn't understand that I needed to pull the node IP and use that and the Port of the service to access the pod. 

## Test Deployment THREE: Using Persistence

Just set `persistence.dataDir.enabled = true` for the helm values. Now there should be a volume that's usable and prevents a deletion of the pod causing the minecraft world being fully deleted.

```sh
minikube start
helm install -f values.yaml volume-test itzg/minecraft --namespace minecraft --create-namespace

# Log in to the Minecraft server via client, make some changes, disconnect

kubectl delete pod volume-test-minecraft-8555595987-6ttqx -n minecraft
watch kubectl get pods -n minecraft
helm uninstall volume-test -n minecraft
kubectl delete namespace minecraft

# Changes persisted!
```

## Test Deployment FOUR: Fixing My Port Issue

I am still getting a weird issue where the `NodePort` port that is created is random... I can connect with the random port, but I'm also setting it in the helm config. Why is it not setting it correctly?

It's because of the YAML CASING!!!! This is how I learn that YAML is case-sensitive. I'm using `NodePort` under `serviceType`, but the value uses `nodePort`; caMel case, not PasCal case. So! I fixed that, and tried setting `25565` as the port, so that when I connect to Minecraft I don't have to set a port (I can just use the default).

However I'm still getting an error saying the range of valid ports is `30000-32767`. It appears this is the standard range on minikube. There may be a reason for this: I'm not sure what the standard is on k3s, but I'll see what happens when we get to Production. In the meantime I used the following command to allow me to use a lower port number:

```
minikube start --extra-config=apiserver.service-node-port-range=20000-61616
```

Now FINALLY I can connect without a port, and it works properly!

## Production Deployment

```powershell
kubectl config get-contexts
kubectl config use-context default
kubectl cluster-info

cd .\minecraftK3S\

helm install -f values.yaml minecraft-xps13 itzg/minecraft -n minecraft --create-namespace
# Error: INSTALLATION FAILED: Service "minecraft-xps13-minecraft" is invalid: spec.ports[0].nodePort: Invalid value: 25565: provided port is not in the valid range. The range of valid ports is 30000-32767
```

Alright. I guess I'm going to stick to the standard ports. And maybe I can port forward once I have PiHole setup... Have a DNS record that forwards minecraft.samg.fyi -> 192.168.50.113:31331.

[Notes on Port exposure](https://github.com/itzg/minecraft-server-charts/issues/18)

Don't have enough enough physical space:
```
pvresize /dev/sda3
pvdisplay
lvextend -L +40G /dev/ubuntu-vg/ubuntu-lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
```

Uninstall and re-install helm with the new port:
```powershell
helm uninstall minecraft-xps13 -n minecraft
helm install -f values.yaml minecraft-xps13 itzg/minecraft -n minecraft --create-namespace
```

Works!