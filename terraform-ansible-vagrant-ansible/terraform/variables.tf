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
