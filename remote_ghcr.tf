# Unfortunately ghcr.io can't access directly in cloud run, only Docker Hub and gcr works directly.
resource "google_artifact_registry_repository" "ghcr" {
  location      = var.region
  repository_id = format("%s-docker-repo", var.project)
  description   = "remote docker repository"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "GitHub Container Registry"
    common_repository {
      uri = "https://ghcr.io"
    }
  }
}
