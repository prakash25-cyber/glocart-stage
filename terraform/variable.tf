variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-south1"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., stage)"
  default     = "stage"
}