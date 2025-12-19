# This module is used to create and manage a Google Cloud Dataflow job.
# It supports both Classic templates (via `google_dataflow_job`) and
# Flex templates (via `google_dataflow_flex_template_job`).
#
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

locals {
  # Controls the creation of the Dataflow job.
  # The job is not created if project_id, name, or template_gcs_path are not provided.
  # This allows for a successful 'terraform plan' without any inputs, which is useful for testing.
  create_job = var.project_id != null && var.name != null && var.template_gcs_path != null
}

resource "google_dataflow_job" "classic_template_job" {
  # This resource creates a Dataflow job from a classic template.
  # It is enabled when the `var.flex_template` is set to false and required variables are provided.
  count = local.create_job && !var.flex_template ? 1 : 0

  # The GCP project ID where the Dataflow job will be created.
  project = var.project_id
  # The region where the Dataflow job will run.
  region = var.region
  # A unique name for the Dataflow job.
  name = var.name
  # The Google Cloud Storage path to the classic Dataflow template.
  template_gcs_path = var.template_gcs_path
  # A Google Cloud Storage path for temporary files.
  temp_gcs_location = var.temp_gcs_location
  # Key-value pairs to pass to the Dataflow job as pipeline parameters.
  parameters = var.parameters
  # User-defined labels to apply to the job.
  labels = var.labels
  # Defines the behavior when the job is deleted from the Terraform state. Can be 'drain', 'cancel', or 'disable'.
  on_delete = var.on_delete
  # The machine type to use for the Dataflow workers.
  machine_type = var.machine_type
  # The maximum number of workers to use for the job.
  max_workers = var.max_workers
  # The service account email to run the workers as.
  service_account_email = var.service_account_email
  # The subnetwork to run the workers in.
  subnetwork = var.subnetwork
  # Specifies the IP address configuration for the workers.
  ip_configuration = var.ip_configuration
  # A list of experiments to enable for the job.
  additional_experiments = var.additional_experiments
  # If true, the job will use the streaming engine.
  enable_streaming_engine = var.enable_streaming_engine

  lifecycle {
    precondition {
      # This precondition ensures that the temp_gcs_location is provided when creating a classic Dataflow job.
      condition     = var.temp_gcs_location != null
      error_message = "The 'temp_gcs_location' variable must be set for Classic Dataflow templates (when flex_template is false)."
    }
  }
}

resource "google_dataflow_flex_template_job" "flex_template_job" {
  # This resource creates a Dataflow job from a Flex template.
  # It is enabled when `var.flex_template` is set to true and required variables are provided.
  # The beta provider is used as it often contains the latest features for Flex templates.
  provider = google-beta
  count    = local.create_job && var.flex_template ? 1 : 0

  # The GCP project ID where the Dataflow job will be created.
  project = var.project_id
  # The region where the Dataflow job will run.
  region = var.region
  # A unique name for the Dataflow job.
  name = var.name
  # The Google Cloud Storage path to the Flex Template JSON file.
  container_spec_gcs_path = var.template_gcs_path
  # Key-value pairs to pass to the Dataflow job as pipeline parameters.
  parameters = var.parameters
  # User-defined labels to apply to the job.
  labels = var.labels
  # Defines the behavior when the job is deleted from the Terraform state. Can be 'drain' or 'cancel'.
  on_delete = var.on_delete
  # The service account email to run the workers as.
  service_account_email = var.service_account_email
  # The subnetwork to run the workers in.
  subnetwork = var.subnetwork
  # The machine type to use for the Dataflow workers.
  machine_type = var.machine_type
  # The maximum number of workers to use for the job.
  max_workers = var.max_workers
  # Specifies the IP address configuration for the workers.
  ip_configuration = var.ip_configuration
  # A list of experiments to enable for the job.
  additional_experiments = var.additional_experiments
  # If true, the job will use the streaming engine.
  enable_streaming_engine = var.enable_streaming_engine
  # If true, Terraform will not wait for the job to terminate upon deletion.
  skip_wait_on_job_termination = var.skip_wait_on_job_termination
}
