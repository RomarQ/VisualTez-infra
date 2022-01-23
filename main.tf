terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.7.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

provider "google" {
  credentials = file("credentials/visualtez-dae3b0b04f33.json")

  project = "visualtez"
  region  = "europe-central1"
  zone    = "europe-central1-c"
}

#
# Create DNS zone
#

resource "google_dns_managed_zone" "visualtez_zone" {
  name        = "visualtez-zone"
  dns_name    = "visualtez.com."
  description = "VisualTez DNS zone"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

#
# Create storage bucket
#

resource "google_storage_bucket" "visualtez_website" {
  name                        = "visualtez.com"
  location                    = "europe-west2"
  force_destroy               = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix          = "index.html"
    not_found_page            = "404.html"
  }
  cors {
    origin                    = ["https://visualtez.com"]
    method                    = ["GET", "HEAD"]
    response_header           = ["*"]
    max_age_seconds           = 3600
  }
}

resource "google_compute_backend_bucket" "visualtez_static_website" {
  name        = "visualtez-static-website"
  bucket_name = google_storage_bucket.visualtez_website.name
  enable_cdn  = true
}

resource "google_storage_bucket_iam_member" "iam_public_access" {
  bucket  = google_storage_bucket.visualtez_website.name
  role    = "roles/storage.objectViewer"
  member  = "allUsers"
}

#
# Configure (Load balancing, DNS, SSL)
#

resource "google_compute_managed_ssl_certificate" "default" {
  name = "visualtez-cert"

  managed {
    domains = ["visualtez.com."]
  }
}

resource "google_compute_url_map" "default" {
  name            = "visualtez-url-map"

  default_service = google_compute_backend_bucket.visualtez_static_website.id

  host_rule {
    hosts        = ["visualtez.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.visualtez_static_website.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_bucket.visualtez_static_website.id
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "visualtez-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "visualtez-forwarding-rule"
  target     = google_compute_target_https_proxy.default.id
  port_range = 443
}

resource "google_dns_record_set" "www_a" {
  name         = "visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 3600
  rrdatas      = [google_compute_global_forwarding_rule.default.ip_address]
}

resource "google_dns_record_set" "www_cname" {
  name          = "www.visualtez.com."
  managed_zone  = google_dns_managed_zone.visualtez_zone.name
  type          = "CNAME"
  ttl           = 300
  rrdatas       = ["visualtez.com."]
}
