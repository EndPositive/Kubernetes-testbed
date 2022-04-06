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
}

# Provisioning on a separate
resource "null_resource" "terraform-ansible-vagrant-ansible" {
  depends_on = [google_compute_instance.terraform-ansible-vagrant-ansible]

  triggers = {
    ssh_username    = var.ssh_username
    ssh_key_public  = var.ssh_key_public
    ssh_key_private = var.ssh_key_private
    nat_ip          = google_compute_instance.terraform-ansible-vagrant-ansible.network_interface[0].access_config[0].nat_ip
  }

  provisioner "local-exec" {
    when    = create
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${self.triggers.ssh_username}' -i '${self.triggers.nat_ip},' --private-key ${self.triggers.ssh_key_private} -e 'pub_key=${self.triggers.ssh_key_public}' ../ansible-system/system-create-playbook.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${self.triggers.ssh_username}' -i '${self.triggers.nat_ip},' --private-key ${self.triggers.ssh_key_private} -e 'pub_key=${self.triggers.ssh_key_public}' ../ansible-system/system-destroy-playbook.yaml"
  }
}
