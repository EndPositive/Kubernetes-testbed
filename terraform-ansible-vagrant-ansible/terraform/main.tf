resource "google_compute_instance" "terraform-ansible-vagrant-ansible" {
  name = "terraform-ansible-vagrant-ansible"

  # Enable VT-x
  machine_type = "n2-highcpu-8"
  advanced_machine_features {
    enable_nested_virtualization = true
  }

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      image = "ubuntu-2004-focal-v20220404"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  provisioner "remote-exec" {
    inline = ["echo 'VM up and running!'"]

    connection {
      host        = self.network_interface[0].access_config[0].nat_ip
      type        = "ssh"
      user        = var.ssh_username
      private_key = file("~/.ssh/google_compute_engine")
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${var.ssh_username}' -i '${self.network_interface[0].access_config[0].nat_ip},' --private-key ${var.ssh_key_private} -e 'pub_key=${var.ssh_key_public}' ../ansible-system/system-create-playbook.yaml"
  }
}
