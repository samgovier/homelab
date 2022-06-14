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