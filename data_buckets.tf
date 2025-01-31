resource "google_storage_bucket" "deepseek_backend" {
  name     = format("%s-deepseek-cloudrun-backend-test", var.project)
  location = var.region
}

resource "google_storage_bucket" "deepseek_frontend" {
  name     = format("%s-deepseek-cloudrun-frontend-test", var.project)
  location = var.region
}
