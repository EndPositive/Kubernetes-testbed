resource "google_compute_instance" "terraform-ansible-load-balancer" {
  count    = var.n_m_nodes > 1 ? 1 : 0
  name     = "terraform-ansible-load-balancer"
  hostname = "load-balancer.internal"

  machine_type = var.machine_type_load_balancer

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      image = var.image_name
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  can_ip_forward = true

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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${var.ssh_username}' -i '${self.network_interface[0].access_config[0].nat_ip},' --private-key ${var.ssh_key_private}  -e 'user=${var.ssh_username} n_m_nodes=${var.n_m_nodes} n_w_nodes=${var.n_w_nodes} hostname=${self.hostname} node_ip=${self.network_interface[0].network_ip} c_eng=${var.c_eng} cni=${var.cni}' ../ansible-kubernetes/master-playbook.yml"
  }
}

resource "google_compute_instance" "terraform-ansible-master" {
  depends_on = [google_compute_instance.terraform-ansible-load-balancer]

  name     = "terraform-ansible-master-1"
  hostname = "master-node-1.internal"

  machine_type = var.machine_type_master

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      image = var.image_name
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  can_ip_forward = true

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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${var.ssh_username}' -i '${self.network_interface[0].access_config[0].nat_ip},' --private-key ${var.ssh_key_private} -e 'user=${var.ssh_username} n_m_nodes=${var.n_m_nodes} n_w_nodes=${var.n_w_nodes} hostname=${self.hostname} node_ip=${self.network_interface[0].network_ip} c_eng=${var.c_eng} cni=${var.cni}' ../ansible-kubernetes/master-playbook.yml"
  }
}

resource "google_compute_instance" "terraform-ansible-master-replica" {
  count      = var.n_m_nodes > 1 ? var.n_m_nodes - 1 : 0
  depends_on = [
    google_compute_instance.terraform-ansible-load-balancer, google_compute_instance.terraform-ansible-master
  ]

  name     = "terraform-ansible-master-${count.index + 2}"
  hostname = "master-node-${count.index + 2}.internal"

  machine_type = var.machine_type_master_replica

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      image = var.image_name
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  can_ip_forward = true

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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${var.ssh_username}' -i '${self.network_interface[0].access_config[0].nat_ip},' --private-key ${var.ssh_key_private} -e 'user=${var.ssh_username} n_m_nodes=${var.n_m_nodes} n_w_nodes=${var.n_w_nodes} hostname=${self.hostname} node_ip=${self.network_interface[0].network_ip} c_eng=${var.c_eng} cni=${var.cni}' ../ansible-kubernetes/master-replica-playbook.yml"
  }
}

resource "google_compute_instance" "terraform-ansible-worker" {
  count      = var.n_w_nodes
  depends_on = [
    google_compute_instance.terraform-ansible-load-balancer, google_compute_instance.terraform-ansible-master
  ]

  name     = "terraform-ansible-worker-${count.index + 1}"
  hostname = "worker-node-${count.index + 1}.internal"

  machine_type = var.machine_type_worker

  boot_disk {
    initialize_params {
      size  = var.boot_disk_size
      image = var.image_name
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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -v -u '${var.ssh_username}' -i '${self.network_interface[0].access_config[0].nat_ip},' --private-key ${var.ssh_key_private} -e 'user=${var.ssh_username} hostname=${self.hostname} node_ip=${self.network_interface[0].network_ip} c_eng=${var.c_eng} cni=${var.cni}' ../ansible-kubernetes/worker-node.yml"
  }
}
