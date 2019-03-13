terraform {
  backend "gcs" {
    bucket = "awesome-devops-tf-state"
    prefix = "cluster"
  }
}
