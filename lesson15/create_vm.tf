terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "vm_name" {
  type = string
  description = "VM name"
}

variable "target_zone" {
  type = string
  description = "Zone"  
}

variable "subnet_map" {
  type = map(string)
  description = "Subnet map from vpc_data"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "vm" {
  name = var.vm_name
  zone = var.target_zone
  platform_id = "standard-v3"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id = var.subnet_map[var.target_zone]
    nat = true
  }

  metadata = {
    ssh-keys = "vagrant:${file("~/.ssh/id_ecdsa.pub")}"
  }
}
