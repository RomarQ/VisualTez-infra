terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.9.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}


# Configure the GCP Provider
provider "google" {
  credentials = file("credentials/visualtez-dae3b0b04f33.json")

  project = var.project
  region  = var.region
  zone    = "europe-west1-b"
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = ["credentials/.aws/credentials"]
  region  = var.aws_region
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
