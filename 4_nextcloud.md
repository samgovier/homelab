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



