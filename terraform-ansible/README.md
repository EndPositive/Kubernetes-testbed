# terraform-ansible

This folder contains the source code for deploying Kubernetes on Google Cloud platform with the following properties:

* Terraform is used to deploy multiple VMs (mimicking Vagrant)
* Ansible playbooks are called based for each type of node (master, master-replica, worker, load balancer)

## How to use?

* Install `google cloud sdk`
* Authenticate with `gcloud auth application-default login`
* In the `terraform` directory:
    * run `terraform init`
    * update the `variables.tf` (or update them from your environment variables TF_VAR_...)
    * run `terraform apply` and accept changes

It takes about ~5 minutes to fully deploy the cluster using this method.

## Debugging

### Connecting to the VM

`gcloud compute ssh --zone "europe-west4-a" "terraform-ansible-master-1"  --project "bsc-jop-zitman"`

### Running Ansible manually

If ansible fails, please check the Terraform output for the ansible command.
The command contains lots of dynamic values that you don't want to determine manually.
