variable "credentials_file" {
  description = "Path to the service account key JSON"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "backend_bucket" {
  description = "GCS bucket for Terraform remote state"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
}