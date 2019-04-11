terraform {
  backend "gcs" {
    bucket = "amweek-devops-terraform"
    prefix = "dev"
  }
}
