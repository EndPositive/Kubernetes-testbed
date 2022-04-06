variable "project" {
  default = "bsc-jop-zitman"
}

variable "region" {
  default = "europe-west4"
}

variable "zone" {
  default = "europe-west4-a"
}

variable "boot_disk_size" {
  default = "100"
}

variable "ssh_username" {}

variable "ssh_key_private" {
  default = "~/.ssh/google_compute_engine"
}

variable "ssh_key_public" {
  default = "~/.ssh/google_compute_engine.pub"
}

variable "image_name" {
  description = "Ubuntu server image"
  default = "ubuntu-2004-focal-v20220404"
}

variable "machine_type" {
  default = "n2-highcpu-2"
}

variable "n_m_nodes" {
  description = "Number of master nodes"
  default = 1
}

variable "n_w_nodes" {
  description = "Number of workers nodes (should be at maximum 9)"
  default = 1
}

variable "c_eng" {
  description = "Container RunTime Engine selection, Docker=1, containerd=2, CRI-O=3"
  default = 1
}

variable "cni" {
  description = "CNI Network Plugin selection. Calico=1, Cilium=2, Weave=3, Flannel=4"
  default = 1
}

variable "machine_type_load_balancer" {
  default = "n2-highcpu-2"
}

variable "machine_type_master" {
  default = "n2-highcpu-2"
}

variable "machine_type_master_replica" {
  default = "n2-highcpu-2"
}

variable "machine_type_worker" {
  default = "n2-highcpu-2"
}
