output "mainnet_external_ip" {
    value = google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_address" "mainnet" {
  name = "mainnet-ipv4-address"
}

resource "google_compute_instance" "mainnet" {
    name                        = "mainnet-vm"
    zone                        = "europe-west1-b"
    machine_type                = "custom-1-4096"
    allow_stopping_for_update   = true

    boot_disk {
        initialize_params {
            type = "pd-ssd"
            image = "projects/ubuntu-os-cloud/global/images/ubuntu-2110-impish-v20220118"
        }
    }

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.mainnet.address
        }
    }

    lifecycle {
        ignore_changes = [attached_disk]
    }

    metadata = {
        ssh-keys = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
    }

    tags = ["rpc-firewall-rules"]
}

resource "google_compute_disk" "mainnet" {
    name  = "mainnet-disk"
    type  = "pd-ssd"
    zone  = "europe-west1-b"
    size  = 40
}

resource "google_compute_attached_disk" "mainnet" {
    disk     = google_compute_disk.mainnet.id
    instance = google_compute_instance.mainnet.id
}
