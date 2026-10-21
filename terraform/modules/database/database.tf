# Create a PostgreSQL Database Instance
resource "google_sql_database_instance" "db_instance" {
  name             = "glocart-${var.environment}-db-instance"
  region           = var.region
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }

  deletion_protection = false
}

# Create the database inside the instance
resource "google_sql_database" "database" {
  name     = "glocart"
  instance = google_sql_database_instance.db_instance.name
}

# Create a database user
resource "google_sql_user" "db_user" {
  name     = "glocart_admin"
  instance = google_sql_database_instance.db_instance.name
  password = "SuperSecretPassword123"
}