terraform {
  required_version = ">= 1.6.0, < 1.8.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.1.0"
    }
  }
}