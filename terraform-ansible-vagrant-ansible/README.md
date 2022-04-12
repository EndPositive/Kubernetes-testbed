# terraform-ansible-vagrant-ansible

This folder contains the source code for deploying Kubernetes on Google Cloud platform with the following properties:

* Terraform is used to deploy a Single VM
* A local terraform provisioner (Ansible: `ansible-system/system-create-playbook.yaml`) is called when the system is ready
* That playbook:
  * installs qemu, libvirt, Vagrant, and Ansible
  * copies Vagrantfile and ansible playbooks to a temporary directory
  * spins up a Vagrant based deployment as described in [../README.md](../README.md) 

## How to use?

* Install `google cloud sdk`
* Authenticate with `gcloud auth application-default login`
* In the `terraform` directory:
  * run `terraform init`
  * update the `variables.tf` (or update them from your environment variables TF_VAR_...)
  * run `terraform apply` and accept changes

It takes about ~15 minutes to fully deploy the cluster using this method.

## Debugging

### Connecting to the VM

`gcloud compute ssh --zone "europe-west4-a" "terraform-ansible-vagrant-ansible"  --project "bsc-jop-zitman"`

### Running Ansible manually

`ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  -v -u 'endpositive' -i '12.34.56.78,' --private-key ~/.ssh/google_compute_engine -e 'pub_key=~/.ssh/google_compute_engine.pub' ../ansible-system/system-create-playbook.yaml`
