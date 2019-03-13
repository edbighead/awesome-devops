resource "google_storage_bucket" "charts" {
  name          = "awesome-devops-helm-charts"
  location      = "us-east1"
  storage_class = "REGIONAL"

  force_destroy = true
}

resource "google_storage_bucket_acl" "charts-acl" {
  bucket = "${google_storage_bucket.charts.name}"

  role_entity = [
    "OWNER:project-owners-55499853457",
    "OWNER:project-editors-55499853457",
    "READER:project-viewers-55499853457",
    "READER:allUsers",
  ]

  depends_on = ["google_storage_bucket.charts"]
}

resource "google_storage_default_object_acl" "default-object-acl" {
  bucket = "${google_storage_bucket.charts.name}"

  role_entity = [
    "OWNER:project-owners-55499853457",
    "READER:allUsers",
  ]

  depends_on = ["google_storage_bucket_acl.charts-acl"]
}

resource "google_storage_bucket_object" "index" {
  name       = "index.yaml"
  source     = "files\\index.yaml"
  bucket     = "${google_storage_bucket.charts.name}"
  depends_on = ["google_storage_default_object_acl.default-object-acl"]
}
