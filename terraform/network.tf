resource "google_compute_address" "ip_address" {
  name = "awesome-devops-app"
}

resource "google_dns_record_set" "app" {
  name = "amweek.${google_dns_managed_zone.work.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.work.name}"

  rrdatas = ["${google_compute_address.ip_address.address}"]
}

resource "google_dns_record_set" "monitoring" {
  name = "monitoring.${google_dns_managed_zone.work.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.work.name}"

  rrdatas = ["${google_compute_address.ip_address.address}"]
}

resource "google_dns_managed_zone" "work" {
  name     = "laur-work"
  dns_name = "laur.work."
}
