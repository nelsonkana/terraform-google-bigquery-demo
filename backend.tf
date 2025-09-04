terraform {
  backend "gcs" {
    bucket      = var.backend_bucket
    prefix      = "terraform/state"
    credentials = var.credentials_file
  }
}