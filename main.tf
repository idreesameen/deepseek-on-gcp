resource "google_cloud_run_v2_service" "deepseek" {
  name                = "deepseek"
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"
  provider            = google-beta
  project             = var.project

  template {
    containers {
      image = format("%s-docker.pkg.dev/%s/%s/ollama-webui/ollama-webui:main", var.region, var.project, google_artifact_registry_repository.ghcr.name)
      resources {
        cpu_idle          = true # Allocate CPU only during a request
        startup_cpu_boost = true # CPU should be boosted on startup of a new container instance above the requested CPU threshold
        limits = {
          cpu    = "1"
          memory = "1024Mi"
        }
      }
      ports {
        container_port = 8080
      }
      env {
        name  = "OLLAMA_API_BASE_URL"
        value = "http://localhost:11434/api"
      }
      volume_mounts {
        name       = "ollama-ui"
        mount_path = "/app/backend/data"
      }

    }
    containers {
      image = "ollama/ollama"
      resources {
        cpu_idle          = true # Allocate CPU only during a request
        startup_cpu_boost = true # CPU should be boosted on startup of a new container instance above the requested CPU threshold
        limits = merge(
          var.gpu_enabled ? {
            cpu              = "4"
            memory           = "16Gi"
            "nvidia.com/gpu" = "1"
            } : {
            cpu    = "1"
            memory = "4Gi"
          }
        )

      }
      volume_mounts {
        name       = "ollama"
        mount_path = "/root/.ollama"
      }
      command = ["sh", "-c", "ollama serve & sleep 5 && ollama pull deepseek-r1:1.5b && wait"]
    }
    dynamic "node_selector" {
      for_each = var.gpu_enabled ? [1] : []
      content {
        accelerator = "nvidia-l4"
      }
    }
    volumes {
      name = "ollama"
      gcs {
        bucket    = google_storage_bucket.deepseek_backend.name
        read_only = false
      }
    }
    volumes {
      name = "ollama-ui"
      gcs {
        bucket    = google_storage_bucket.deepseek_frontend.name
        read_only = false
      }
    }
    scaling {
      min_instance_count = 0 # Instance will do a coldstart when it hits traffic, there will be a small cold-start latency 
      max_instance_count = 4
    }
  }

}

resource "google_cloud_run_service_iam_binding" "noauth" {
  location = google_cloud_run_v2_service.deepseek.location
  service  = google_cloud_run_v2_service.deepseek.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
