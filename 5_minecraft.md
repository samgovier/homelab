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