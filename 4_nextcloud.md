# Nextcloud Deployment

## Test deployment: using minikube

[minikube tutorial](https://kubernetes.io/docs/tutorials/hello-minikube/)

[nextcloud step-by-step](https://blog.true-kubernetes.com/self-host-nextcloud-using-kubernetes/)

[docker image](https://hub.docker.com/_/nextcloud/)

```powershell
minikube start
cd /nextcloudMinikube
minikube kubectl
kubectl create deployment nextcloud-mysql --image=mysql/mysql:5.7 --dry-run=client -o yaml > nextcloud.yaml

kubectl create secret generic nextcloud-db-secret `
    --from-literal=MYSQL_ROOT_PASSWORD=xxx `
    --from-literal=MYSQL_USER=nextcloud `
    --from-literal=MYSQL_PASSWORD=xxx

minikube addons enable ingress

kubectl apply -f nextcloud.yaml

minikube ip

# add IP to hosts files, temporarily

# 172.18.143.204 files.mysite.test

# browse http://X.X.X.X
```

## Production deployment of k3s

### [Installing K3s according to Rancher documentation](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

On the Production server xps13:
```sh
sudo -s
curl -sfL https://get.k3s.io | sh -
ls /etc/rancher/k3s -lah
cat /etc/rancher/k3s/k3s.yaml # This is the kubeconfig file! It has all the permissions... but fine for me and my local cluster
```

### [Installing and configuring Kubectl according to k8s documetation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

On my local machine:
```sh
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl
kubectl version --client
mkdir -p ~/.kube
vim ~/.kube/config # insert kubeconfig from the server here: modify the IP to the server IP
kubectl cluster-info # It's working!!!
kubectl get all -A
```

We're up and running!! That was... suspiciously easy

### Verify deploying nextcloud configuration

From the root of this repo
```sh
mkdir nextcloudK3S
ls nextcloudMinikube/
cp nextcloudMinikube/nextcloud.yaml nextcloudK3S/nextcloud.yaml
cd nextcloudK3S/
ls
kubectl apply -f nextcloud.yaml
kubectl get all -n nextcloud
kubectl delete -f nextcloud.yaml
```

### Customize for Production deployment

* Change storage to `30Gi`
* Change host to the IP of the xps13 laptop, but this didn't work... how to make it easily accessible. DNS for the router?

```powershell
kubectl create secret generic nextcloud-db-secret -n nextcloud `
    --from-literal=MYSQL_ROOT_PASSWORD=xxx `
    --from-literal=MYSQL_USER=nextcloud `
    --from-literal=MYSQL_PASSWORD=xxx

kubectl apply -f nextcloud.yaml
```

## K3S TODO config check and enhance
* `k3s check-config`
    * turn off swap?
    * CONFIG_RT_GROUP_SHED: um yes? That seems good based on a quick DDG search
    * CONFIG_INET_XFRM_MODE_TRANSPORT: hmmmmm seems like a network thing
* `k3s etcd-snapshot`, and snapshots/backups, etcd, persistent volumes
* `k3s secrets-encrypt`?