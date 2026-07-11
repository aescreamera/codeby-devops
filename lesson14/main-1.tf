terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

data "yandex_vpc_network" "default_net" {
  name = "default"
}

data "yandex_vpc_subnet" "subnet_public" {
  name = "default-ru-central1-a"
}

data "yandex_vpc_subnet" "subnet_private" {
  name = "default-ru-central1-b"
}

resource "yandex_vpc_security_group" "public_sg" {
  name = "public-sg"
  network_id = data.yandex_vpc_network.default_net.id

  ingress {
    protocol = "TCP"
    description = "Allow HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 80
  }

  ingress {
    protocol = "TCP"
    description = "Allow HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 443
  }

  ingress {
    protocol = "TCP"
    description = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22
  }

  egress {
    protocol = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private_sg" {
  name = "private-sg"
  network_id = data.yandex_vpc_network.default_net.id

  ingress {
    protocol = "TCP"
    description = "Allow 8080"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 8080
  }

  ingress {
    protocol = "TCP"
    description = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22
  }

  egress {
    protocol = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  cloud_init = <<EOF
#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
users:
  - name: vagrant
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${file("~/.ssh/id_ecdsa.pub")}
EOF
}

resource "yandex_compute_instance" "public_vm" {
  name = "public-vm"
  zone = "ru-central1-a"
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
    subnet_id = data.yandex_vpc_subnet.subnet_public.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.public_sg.id]
  }

  metadata = {
    user-data = local.cloud_init
  }
}

resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = data.yandex_vpc_subnet.subnet_private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_sg.id]
  }

  metadata = {
    user-data = local.cloud_init
  }
}
