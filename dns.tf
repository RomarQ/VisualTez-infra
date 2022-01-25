# Website records

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

# Ithaca records

resource "google_dns_record_set" "ithacanet_a" {
  name         = "ithacanet.visualtez.com."
  managed_zone = google_dns_managed_zone.visualtez_zone.name
  type         = "A"
  ttl          = 3600
  rrdatas      = [google_compute_instance.ithacanet.network_interface.0.access_config.0.nat_ip]
}
