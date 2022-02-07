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

# Hangzhounet records

resource "google_dns_record_set" "hangzhounet_a" {
  name         = "hangzhounet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 3600
  rrdatas      = [google_compute_instance.hangzhounet.network_interface.0.access_config.0.nat_ip]
}

# Ithaca records

resource "google_dns_record_set" "ithacanet_a" {
  name         = "ithacanet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 3600
  rrdatas      = [google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip]
}

# Mainnet records

resource "google_dns_record_set" "mainnet_a" {
  name         = "mainnet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 3600
  rrdatas      = [google_compute_instance.mainnet.network_interface.0.access_config.0.nat_ip]
}
