# Create a Service Account for application pods
resource "google_service_account" "app_sa" {
  account_id   = "glocart-${var.environment}-sa"
  display_name = "Glocart App Service Account"
}

# Give permission to write logs
resource "google_project_iam_member" "sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}