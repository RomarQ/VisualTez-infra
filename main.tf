terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.9.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

provider "google" {
  credentials = file("credentials/visualtez-dae3b0b04f33.json")

  project = var.project
  region  = var.region
  zone    = "europe-west1-b"
}

# Create RPC firewall

resource "google_compute_firewall" "rpc_firewall_rules" {
    name        = "rpc-firewall-rules"
    network     = "default"

    allow {
        protocol  = "tcp"
        ports     = ["80", "443", "9732"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["rpc-firewall-rules"]
}
