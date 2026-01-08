# This module is used to create and manage Google Cloud Dataflow jobs.
# It supports both classic templates and Flex Templates by using the
# `google_dataflow_job` resource and toggling the `use_flex_template` variable.
#
# The module encapsulates common configurations such as worker settings,
# networking, service accounts, and job parameters, providing a reusable
# interface for launching various Dataflow pipelines.
#
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

data "google_client_config" "current" {}

locals {
  # The google_client_config data source can return empty strings for project and region
  # if they are not configured in the provider. Coalesce fails on empty strings,
  # so we convert them to nulls before using them.
  provider_project = data.google_client_config.current.project != "" ? data.google_client_config.current.project : null
  provider_region  = data.google_client_config.current.region != "" ? data.google_client_config.current.region : null

  # Selects the correct template path based on whether a Flex Template is used.
  effective_template_path = var.use_flex_template ? var.container_spec_gcs_path : var.template_gcs_path

  # Merges user-provided parameters with the num_workers setting if provided.
  # The `numWorkers` parameter is used by many templates to set a fixed number of workers.
  effective_parameters = merge(
    var.parameters,
    var.num_workers != null ? { "numWorkers" = var.num_workers } : {}
  )
}

resource "google_dataflow_job" "job" {
  # The GCP project ID where the Dataflow job will run.
  project = coalesce(var.project_id, local.provider_project)
  # The name for the Dataflow job. Must be unique within the project and region.
  name = var.name
  # The region where the Dataflow job will run.
  region = coalesce(var.region, local.provider_region)
  # The zone where the Dataflow job will run. Let the service choose the zone by not setting it.
  zone = var.zone
  # The GCS path to the Dataflow template. This can be a classic or a Flex Template.
  template_gcs_path = local.effective_template_path
  # A GCS path for the Dataflow service to stage temporary files.
  temp_gcs_location = var.temp_gcs_location
  # Key-value pairs to pass to the Dataflow job as parameters.
  parameters = local.effective_parameters
  # Labels to apply to the job.
  labels = var.labels
  # The machine type to use for the Dataflow workers.
  machine_type = var.machine_type
  # The maximum number of workers to use for the job. For autoscaling.
  max_workers = var.max_workers
  # The service account email to run the workers as.
  service_account_email = var.service_account_email
  # The VPC network to host the workers in.
  network = var.network
  # The subnetwork to host the workers in.
  subnetwork = var.subnetwork
  # Configuration for worker IP address assignment. Can be `WORKER_IP_PUBLIC` or `WORKER_IP_PRIVATE`.
  ip_configuration = var.ip_configuration
  # The Cloud KMS key to protect the job state.
  kms_key_name = var.kms_key_name
  # A list of experiments to enable for the job.
  additional_experiments = var.additional_experiments
  # If true, enables the Dataflow Streaming Engine for streaming jobs. Not applicable for Flex Templates.
  enable_streaming_engine = var.use_flex_template ? null : var.enable_streaming_engine
  # Defines the behavior when the resource is destroyed. Can be `drain`, `cancel`, or `terminate`.
  on_delete = var.on_delete

  lifecycle {
    precondition {
      condition     = var.project_id != null || local.provider_project != null
      error_message = "A project ID must be specified either through the 'project_id' variable or the provider configuration."
    }
    precondition {
      condition     = var.region != null || local.provider_region != null
      error_message = "A region must be specified either through the 'region' variable or the provider configuration."
    }
    precondition {
      condition     = var.use_flex_template ? var.container_spec_gcs_path != null : var.template_gcs_path != null
      error_message = "When 'use_flex_template' is ${var.use_flex_template}, the corresponding template path variable ('container_spec_gcs_path' or 'template_gcs_path') must be set."
    }
    precondition {
      condition     = var.num_workers == null || var.max_workers == null
      error_message = "The 'num_workers' and 'max_workers' variables are mutually exclusive."
    }
  }
}
