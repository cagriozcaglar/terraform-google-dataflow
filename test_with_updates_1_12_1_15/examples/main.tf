# This file provisions all the necessary resources to run the Dataflow Flex Template example.
# This includes enabling APIs, creating a GCS bucket for staging/templates,
# uploading a dummy template file, creating a dedicated service account with
# appropriate permissions, and finally, instantiating the module.

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable necessary APIs
resource "google_project_service" "dataflow" {
  project = var.project_id
  service = "dataflow.googleapis.com"
}

resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}

# A random suffix for resource names to ensure they are unique
resource "random_id" "suffix" {
  byte_length = 4
}

# GCS bucket for Dataflow staging and templates
resource "google_storage_bucket" "bucket" {
  project      = var.project_id
  name         = "dataflow-flex-example-bucket-${random_id.suffix.hex}"
  location     = var.region
  force_destroy = true
}

# A dummy Flex Template specification file.
# This example uses a public sample template for running Beam SQL queries.
resource "google_storage_bucket_object" "template_spec" {
  name    = "templates/streaming-beam-sql.json"
  bucket  = google_storage_bucket.bucket.name
  content = jsonencode({
    image = "gcr.io/google-samples/dataflow/streaming-beam-sql:latest",
    sdk_info = {
      language = "JAVA"
    },
    metadata = {
      name        = "Streaming_Beam_Sql",
      description = "A streaming Beam SQL pipeline.",
      parameters = [
        {
          name      = "query",
          label     = "SQL Query",
          help_text = "The Beam SQL query to run.",
          is_optional = false
        }
      ]
    }
  })
}

# Service Account for the Dataflow job
resource "google_service_account" "dataflow_sa" {
  project      = var.project_id
  account_id   = "dataflow-flex-example-sa-${random_id.suffix.hex}"
  display_name = "Dataflow Flex Template Example SA"
}

# Grant the Dataflow Worker role to the Service Account
resource "google_project_iam_member" "dataflow_worker" {
  project = var.project_id
  role    = "roles/dataflow.worker"
  member  = "serviceAccount:${google_service_account.dataflow_sa.email}"
}

# Grant the Service Account permissions to access the GCS bucket
resource "google_storage_bucket_iam_member" "storage_admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataflow_sa.email}"
}


# Instantiate the Dataflow Flex Template module
module "dataflow_flex_job" {
  source = "../../"

  # Required variables
  name                = "dataflow-flex-simple-example-${random_id.suffix.hex}"
  template_gcs_path   = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.template_spec.name}"
  temp_gcs_location   = "gs://${google_storage_bucket.bucket.name}/temp"

  # Optional variables with example values
  project_id          = var.project_id
  region              = var.region
  service_account_email = google_service_account.dataflow_sa.email
  machine_type        = "e2-medium"
  max_workers         = 3
  enable_streaming_engine = true
  parameters = {
    # This parameter is defined in the dummy template spec above
    query = "SELECT 1 AS test_column;"
  }
  labels = {
    example-name = "simple-dataflow-flex-template"
    created-by   = "terraform"
  }

  # Ensure prerequisite resources are created before the job
  depends_on = [
    google_project_service.dataflow,
    google_project_iam_member.dataflow_worker,
    google_storage_bucket_iam_member.storage_admin
  ]
}
