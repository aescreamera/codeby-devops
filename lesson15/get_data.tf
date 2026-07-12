terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "network_name" {
  type = string
  description = "default"
}

data "yandex_vpc_network" "target_net" {
  name = var.network_name
}

data "yandex_vpc_subnet" "subnet_a" {
  name = "${var.network_name}-ru-central1-a"
}

data "yandex_vpc_subnet" "subnet_b" {
  name = "${var.network_name}-ru-central1-b"
}

data "yandex_vpc_subnet" "subnet_d" {
  name = "${var.network_name}-ru-central1-d"
}

data "yandex_vpc_subnet" "subnet_e" {
  name = "${var.network_name}-ru-central1-e"
}

output "subnet_ids_by_zone" {
  value = {
    "ru-central1-a" = data.yandex_vpc_subnet.subnet_a.id
    "ru-central1-b" = data.yandex_vpc_subnet.subnet_b.id
    "ru-central1-d" = data.yandex_vpc_subnet.subnet_d.id
    "ru-central1-e" = data.yandex_vpc_subnet.subnet_e.id
  }
}
