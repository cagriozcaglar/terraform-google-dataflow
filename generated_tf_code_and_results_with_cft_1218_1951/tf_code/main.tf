# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# This module creates a Google Cloud Dataflow job from either a classic or a Flex Template.
# It is designed to be a flexible and reusable component for launching both batch and streaming pipelines.
# To launch a Flex Template job, provide the GCS path to the template spec file in `template_gcs_path`
# and include the `containerSpecGcsPath` in the `parameters` map.
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# The `locals` block is used to define local values that can be reused throughout the module.
locals {
  # Determines if the Dataflow job should be created based on the presence of required variables.
  create_job = var.name != null && var.template_gcs_path != null && var.temp_gcs_location != null

  # Sanitize the job name to meet Dataflow requirements.
  # The name must be at most 63 characters, match the regex `[a-z]([-a-z0-9]{0,61}[a-z0-9])?`.
  # We truncate the base name to 54 characters to leave space for the hyphen and the 8-character random suffix.
  # We also replace underscores with hyphens, a common convention.
  sanitized_name = local.create_job ? substr(lower(replace(var.name, "_", "-")), 0, 54) : ""
}

# A random_id resource is used to generate a unique suffix for the job name.
# This prevents naming conflicts and allows for multiple instances of the same job to be created.
resource "random_id" "job_suffix" {
  # Only create a random suffix if the job itself is being created.
  count = local.create_job ? 1 : 0

  # The byte_length determines the length of the random hexadecimal string.
  byte_length = 4
}

# This resource defines a Dataflow job from a template (classic or Flex).
resource "google_dataflow_job" "main" {
  # Only create the job if the required variables are provided.
  count = local.create_job ? 1 : 0

  # The GCP project ID where the job will run. Defaults to the provider's project if not specified.
  project = var.project_id
  # The region where the job will run.
  region = var.region
  # The unique name for the job, with a random suffix. Name is sanitized to meet GCP requirements.
  name = "${local.sanitized_name}-${random_id.job_suffix[0].hex}"

  # The GCS path to the template file (for classic templates) or the template spec file (for Flex Templates).
  template_gcs_path = var.template_gcs_path
  # The GCS path for staging temporary files.
  temp_gcs_location = var.temp_gcs_location

  # The zone where the job will run.
  zone = var.zone
  # Pipeline-specific parameters. For Flex Templates, this must include 'containerSpecGcsPath'.
  parameters = var.parameters
  # Labels to apply to the job.
  labels = var.labels
  # Action to take on resource destruction.
  on_delete = var.on_delete

  # Worker and environment configuration.
  service_account_email   = var.service_account_email
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_configuration        = var.ip_configuration
  machine_type            = var.machine_type
  max_workers             = var.max_workers
  additional_experiments  = var.additional_experiments
  enable_streaming_engine = var.enable_streaming_engine
  kms_key_name            = var.kms_key_name
}
