terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.18.0"
    }
  }
}

provider "google" {
  project = var.project
}

terraform {
  required_version = ">= 1.7"
}
