output "ithacanet_external_ip" {
    value = google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_address" "ithacanet" {
  name = "ithacanet-ipv4-address"
}

resource "google_compute_instance" "ithacanet" {
    name                        = "ithacanet-vm"
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
            nat_ip = google_compute_address.ithacanet.address
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

resource "google_compute_disk" "ithacanet" {
    name  = "ithacanet-disk"
    type  = "pd-ssd"
    zone  = "europe-west1-b"
    size  = 130
}

resource "google_compute_attached_disk" "ithacanet" {
    disk     = google_compute_disk.ithacanet.id
    instance = google_compute_instance.ithacanet.id
}
