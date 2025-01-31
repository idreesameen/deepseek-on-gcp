variable "region" {
  #default     = "europe-west4"
  description = "Decide in which GCP region you want to run DeepSeek and store data"
}

variable "project" {
  #default     = ""
  description = "Create an enter your GCP project here"
}

variable "gpu_enabled" {
  type        = bool
  default     = false
  description = "GPU configuration is only supported in regions: us-central1, asia-southeast1, europe-west4"
}
