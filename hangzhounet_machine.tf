output "hangzhounet_external_ip" {
    value = google_compute_instance.hangzhounet.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_address" "hangzhounet" {
  name = "hangzhounet-ipv4-address"
}

resource "google_compute_instance" "hangzhounet" {
    name         = "hangzhounet-vm"
    machine_type = "e2-standard-2"
    zone         = "europe-west1-b"

    boot_disk {
        initialize_params {
            type = "pd-ssd"
            image = "projects/ubuntu-os-cloud/global/images/ubuntu-2110-impish-v20220118"
        }
    }

    network_interface {
        network = "default"

        access_config {
            nat_ip = google_compute_address.hangzhounet.address
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

resource "google_compute_disk" "hangzhounet" {
    name  = "hangzhounet-disk"
    type  = "pd-ssd"
    zone  = "europe-west1-b"
    size  = 40
}

resource "google_compute_attached_disk" "hangzhounet" {
    disk     = google_compute_disk.hangzhounet.id
    instance = google_compute_instance.hangzhounet.id
}
