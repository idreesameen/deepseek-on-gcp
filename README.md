# Deepseek Cloud Run Deployment

This repository contains Terraform configuration for deploying Deepseek on Google Cloud Run. The setup ensures efficient resource usage, cost-effectiveness, and flexibility in scaling, while maintaining full control over stored data.

## Overview
The deployment consists of two primary containers:
1. **Ollama Web UI**: Serves the frontend interface.
2. **Ollama API Server**: Runs the model and serves requests.

## Features
- **Google Cloud Run**: Fully managed serverless execution environment.
- **Automatic Scaling**: Scales up to 4 instances based on traffic and scales down to 0 when idle.
- **Cold-Start Consideration**: A slight delay on the first request due to container startup.
- **Cost Optimization**: Pay only when the service is in use.
- **GPU/CPU Support**: Can leverage GPU (NVIDIA L4) when enabled.
- **Persistent Storage**: Data is stored in Google Cloud Storage (GCS) buckets.
- **Full Control**: All data remains within our controlled GCP project.

## Deployment Details
- **Ingress**: Allows all incoming traffic.
- **Container Resource Allocation**:
  - **Ollama Web UI**: 1 CPU, 1GB RAM.
  - **Ollama API Server**: 1 CPU, 4GB RAM (optional GPU acceleration).
- **Environment Variable**:
  - `OLLAMA_API_BASE_URL` is set to `http://localhost:11434/api`.
- **Volumes**:
  - `ollama-ui` (Frontend data) stored in a GCS bucket.
  - `ollama` (Model data) stored in a GCS bucket.

## Deployment Instructions
1. Configure `var.region`, `var.project`, and enable GPU if needed.
2. Ensure required GCP services are enabled:
   - Cloud Run
   - Artifact Registry
   - Cloud Storage
3. Apply the Terraform configuration:
   ```sh
   terraform init
   terraform plan -var="project=<your-gcp-project-id>" -var="region=europe-west3"
   ```

## Free Trial on GCP
Google Cloud offers a **$300 free trial** for new accounts, which can be used to deploy this setup at no cost. If you have already used the free trial, you can create a new email for another trial (just for fun 😄).

## Notes
- First request may experience a cold-start delay.
- GPU is optional and only provisioned if `var.gpu_enabled` is set to `true`.
- Cloud Run ensures efficient cost management by stopping instances when not in use.

## Contact
For any issues or improvements, please raise a GitHub issue or contact the development team .
