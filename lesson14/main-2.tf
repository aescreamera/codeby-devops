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

resource "yandex_compute_instance" "imported_vm" {
    folder_id                 = "b1g02clasq272a2dbvjf"
    hostname                  = "third-vm"
    metadata                  = {
        "enable-oslogin"          = "true"
        "private_ui_created_from" = "console"
    }
    name                      = "third-vm"
    platform_id               = "standard-v3"
    service_account_id        = "ajeu7qlp57sa4q2f0q9p"

    boot_disk {
        auto_delete = true
        device_name = "fhmcouacv8hdofg83lui"
        disk_id     = "fhmcouacv8hdofg83lui"
        mode        = "READ_WRITE"

        initialize_params {
            block_size  = 4096
            description = null
            image_id    = "fd8dcjve5vsdhbqs6nqj"
            kms_key_id  = null
            name        = "disk-ubuntu-24-04-lts-1783779375262"
            size        = 10
            snapshot_id = null
            type        = "network-ssd"
        }
    }

    network_interface {
        ip_address         = "10.128.0.16"
        nat                = true
        security_group_ids = [
            "enp6k70e4jdltqdphm6u",
        ]
        subnet_id          = "e9b8ljd8n6qlfm8lg19r"
    }

    resources {
        core_fraction = 100
        cores         = 2
        gpus          = 0
        memory        = 2
    }
}

