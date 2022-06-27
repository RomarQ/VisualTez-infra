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

# Storage record

resource "google_dns_record_set" "storage_a" {
  name         = "storage.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip]
}

# Testing API

resource "google_dns_record_set" "testing_api_a" {
  name         = "testing.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [aws_instance.jakartanet.public_ip]
}

# Jakarta records

resource "google_dns_record_set" "jakartanet_a" {
  name         = "jakartanet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [aws_instance.jakartanet.public_ip]
}


# Ithaca records

resource "google_dns_record_set" "ithacanet_cname" {
  name         = "ithacanet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [google_dns_record_set.ghostnet_a.name]
}

resource "google_dns_record_set" "ghostnet_a" {
  name         = "ghostnet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip]
}

# Mainnet records

resource "google_dns_record_set" "mainnet_a" {
  name         = "mainnet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [aws_instance.mainnet.public_ip]
}
