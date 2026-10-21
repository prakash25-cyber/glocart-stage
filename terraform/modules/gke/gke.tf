# Create a Kubernetes Cluster
resource "google_container_cluster" "primary" {
  name               = "glocart-${var.environment}-cluster"
  location           = var.region
  initial_node_count = 1
  network            = google_compute_network.vpc.id
  subnetwork         = google_compute_subnetwork.subnet.id

  deletion_protection = false

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}