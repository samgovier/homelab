# Azure Setup


## Account Setup
Getting Azure setup so that I can deploy some services there, using Terraform.
1. Logging in and setting up access to Azure Portal with my personal account
2. Setup a free trial account
3. Run the following to test access from the `tf` directory:
```
az login
terraform init
```

## Basic Items
Start with creating basic building blocks for a private network:
* Variables: For Introducing Sensitive items
    * Using `terraform.tfvars` in the terraform directory
* Resource Group: `resourcegroup.tf`
* Network: `network.tf`
    * VNet
    * NSG
    * VPN (for point-to-site network)

Trying to find available subscriptions I can use... googling isn't really doing it for me.

Found the proper commands under `az account`:

```
az account show
az account list-locations -o table
```

North Central US is probably best, `northcentralus`.
Huh, I wonder where that is...? Looks like NCUS is Chicago area, CUS is Des Moines Iowa. So north central US is a little bit closer to Madison

During writing, I'm running `terraform fmt` and `terraform validate` to keep code clean and functional

## ACI Module

Creating a module under `tf\aci` for Azure Container Instances. Adding some default items, and this will probably expand as this gets used more...

## Gitea Deployment

## Vaultwarden Deployment

## NEXT STEPS

* Create Production
* More permanent connection method: VPN? Site-to-site? Public?
* tfstate secure storage in Azure
* More Module-izing