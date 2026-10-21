# Terraform configure to the gcp providers 
terraform {
    required_version = ">=1.0"
    required_provider {
        google = {
            source = "hashicorp/google"
            version ="~>5.0"
        }
    }
}

providers "google" {
    project = "project_id"
    region = "region_name"
    zone = "zone_name"
}