resource "google_container_cluster" "primary" {
  provider           = "google-beta"
  name               = "my-gke-cluster"
  min_master_version = "1.12.5-gke.5"

  node_pool {
    name               = "kubernetes-node"
    initial_node_count = 1
    version            = "1.12.5-gke.5"

    node_config {
      image_type   = "UBUNTU"
      machine_type = "n1-standard-2"
      preemptible  = "false"
      disk_type    = "pd-standard"
      disk_size_gb = "50"

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
      ]

      metadata {
        "disable-legacy-endpoints" = "true"
      }
    }

    autoscaling {
      min_node_count = "1"
      max_node_count = "3"
    }
  }

  timeouts {
    create = "30m"
    update = "1h"
    delete = "30m"
  }
}
