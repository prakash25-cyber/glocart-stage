output "gke_cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "Kubernetes Cluster API Endpoint"
}

output "database_ip" {
  value       = google_sql_database_instance.db_instance.public_ip_address
  description = "Public IP address of the database"
}