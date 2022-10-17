# Terraform Workshop
This is a short introduction to using Terraform in combination with Azure. We will be provisioning:

- a virtual network with 2 subnets
- a virtual machine scale set with vm's running nginx
- a load balancer with a public ip-address fronting the virtual machine scale set

## Prequisites

1. Clone this repo
2. Install the [Terraform single binary](https://www.terraform.io/downloads)
3. Export Azure Service Principal credentials (actual values will be provided)

```
export ARM_TENANT_ID=*******
export ARM_SUBSCRIPTION_ID=*******
export ARM_CLIENT_ID=*******
export ARM_CLIENT_SECRET=*******
```


## Step 1: Terraform files
Have a look at the terraform files in this repository. The resource types usually give a good indication which component will be provisioned. Note that some resources reference other resources, creating an implicit dependency. For example the virtual machine scale set references the load balancer backend pool it is part of. Terraform will use these implicit dependencies to determine the order in which the resources need to be created/destroyed.

In the `variables.tf` file change the default values for the `workshop_user` and  `vm_password` variables. The supplied password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following
- Contains an uppercase character
- Contains a lowercase character
- Contains a numeric digit
- Contains a special charact

Control characters are not allowed

> Note that in the real world we would never store a password in this file to create a VM but we would use ssh keys instead. 

## Step 2: Initialize Terraform
The `terraform ini`t command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

Using the shell (bash/powershell) where you exported the `ARM_*` variables, go to the `terraform` directory of this repository and type:

```
terraform init
```


## Step 3: Let Terraform create a plan of changes
The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure. By default, when Terraform creates a plan it:

* Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
* Compares the current configuration to the prior state and noting any differences.
* Proposes a set of change actions that should, if applied, make the remote objects match the configuration.

To create a plan for our Azure infra, just type:

```
terraform plan
```

Quicky study the changes that Terraform wants to apply. You should recognize the resources from the Terraform files you studied in step 1.


## Step 4: Let Terraform execute the planned changes
If you are happy with the changes you can proceed with:

```
terraform apply
```

This command executes the actions proposed in the Terraform plan of the previous step. Monitor the console output and note the order of the actions. Where possible Terraform will execute changes in parallel.

## Step 5: Review the resources in Azure Portal
Logon to `portal.azure.com` with the separately provided workshop account and go to the resource group `rg-workshop-<your name>`. Checkout the created resources. Do you have virtual machine scale set with 2 instances running?

There should be a public ip-address with a DNS name in the form of `workshop-knowit-<your name>.westeurope.cloudapp.azure.com`. Try to navigate to this domain (plain http) in your browser. It's not working.

## Step 6: Fix the problem
Unfortunately we forgot to configure a load balancer rule that forward all traffic on frontend port `80` to backend pool port `8080`. It is your task to fix this by adding a [azurerm_lb_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) to the `load-balancer.tf` file. There is already a probe in the same configuration file that you can use for this rule.

After you have added the `azurerm_lb_rule` run a `terraform plan`. If you are happy with the proposed changes you can apply them using `terraform apply`. When done, your website should be up and running.


## Step 7: Optional stuff you can do
- Check out the `terraform.tfstate` file in your terraform directory. It contains a respresentation of the resources that Terraform think are now deployed. Normally this file would not be stored locally but either in a Terraform Enterprise Workspace or in some form of object storage (e.g. S3/Azure Storage Account).
- Delete the virtual machine scale set in Azure Portal and run a `terraform apply`. Terraform will re-create the deleted component.

## Step 8: CLEAN UP PLEASE !!!!
In order not to leave me with a huge Azure invoice please cleanup after yourself:

```
terraform destroy
```













