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

module "network_info" {
  source = "./modules/vpc_data"
  network_name = "default"
}

module "vm_in_zone_a" {
  source = "./modules/compute_vm"
  vm_name = "custom-vm-a"
  target_zone = "ru-central1-a"
  subnet_map = module.network_info.subnet_ids_by_zone
}

module "vm_in_zone_b" {
  source      = "./modules/compute_vm"
  vm_name     = "custom-vm-b"
  target_zone = "ru-central1-b"
  subnet_map  = module.network_info.subnet_ids_by_zone
}
