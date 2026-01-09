# This resource creates a random string to ensure a unique Dataflow job name when one isn't provided.
resource "random_string" "job_name_suffix" {
  # The length of the random string suffix.
  length = 8
  # The random string will not contain special characters.
  special = false
  # The random string will not contain uppercase letters.
  upper = false
}

# This locals block defines a sanitized and unique job name.
locals {
  # Generate a unique job name if one is not provided.
  # The name must consist of only the characters `[a-z]`, `[0-9]`, and `-`.
  # It must start with a letter and end with a letter or a number, and be at most 63 characters long.
  job_name = substr(lower(replace(coalesce(var.name, "dataflow-job-${random_string.job_name_suffix.id}"), "_", "-")), 0, 63)
}

# This resource creates a Dataflow job from either a Classic or Flex template.
resource "google_dataflow_job" "this" {
  # A unique name for the Dataflow job.
  name = local.job_name
  # The GCS path to the template file. This can be a Classic or Flex Template.
  template_gcs_path = var.job_type == "FLEX" ? var.flex_template_gcs_path : var.template_gcs_path
  # The GCS path for staging temporary files. Required for Classic templates.
  temp_gcs_location = var.temp_gcs_location
  # The GCP project ID where the job will run.
  project = var.project_id
  # The region where the job will run.
  region = var.region
  # The zone where the job will run. Applicable only for CLASSIC jobs.
  zone = var.zone
  # Key-value pairs to be passed to the job as parameters.
  parameters = var.parameters
  # User-defined labels to apply to the job.
  labels = var.labels
  # List of experiments to enable for the job. Applicable only for CLASSIC jobs.
  additional_experiments = var.additional_experiments
  # The service account email to run the job as.
  service_account_email = var.service_account_email
  # The machine type to use for the worker VMs.
  machine_type = var.machine_type
  # The maximum number of workers permitted to run.
  max_workers = var.max_workers
  # The VPC network to which the workers will be deployed.
  network = var.network
  # The VPC subnetwork to which the workers will be deployed.
  subnetwork = var.subnetwork
  # The configuration for VM IPs.
  ip_configuration = var.ip_configuration
  # Indicates if the job should use the streaming engine feature.
  enable_streaming_engine = var.enable_streaming_engine
  # Defines the behavior on resource destruction ('drain' or 'cancel').
  on_delete = var.on_delete
  # If true, Terraform will not wait for job termination on destroy/update.
  skip_wait_on_job_termination = var.skip_wait_on_job_termination

  lifecycle {
    precondition {
      condition     = var.job_type == "CLASSIC" ? var.template_gcs_path != null : true
      error_message = "The 'template_gcs_path' variable must be set when 'job_type' is 'CLASSIC'."
    }
    precondition {
      condition     = var.job_type == "CLASSIC" ? var.temp_gcs_location != null : true
      error_message = "The 'temp_gcs_location' variable must be set when 'job_type' is 'CLASSIC'."
    }
    precondition {
      condition     = var.job_type == "FLEX" ? var.flex_template_gcs_path != null : true
      error_message = "The 'flex_template_gcs_path' variable must be set when 'job_type' is 'FLEX'."
    }
  }
}
