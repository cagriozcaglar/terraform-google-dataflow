# The main.tf file contains the core logic for creating Dataflow jobs.
# It uses a unified `google_dataflow_job` resource to create either a classic
# template job or a Flex Template job based on the `use_flex_template` input variable.
# This approach aligns with the Google Provider version 4.25+ which deprecates the
# separate `google_dataflow_flex_template_job` resource.

locals {
  # A condition to check if the necessary parameters for job creation are provided.
  # This is used to conditionally create the Dataflow job resource.
  can_create_job = var.use_flex_template ? var.container_spec_gcs_path != null : var.template_gcs_path != null

  # The `google_dataflow_job` resource expects certain worker configuration options to be passed
  # within the `parameters` map for template-based jobs. This local map merges the user-provided
  # parameters with specific worker settings defined as variables.
  # The num_workers argument is deprecated at the top level, so it must be passed as a parameter.
  job_parameters = merge(
    var.parameters,
    var.num_workers != null ? { "numWorkers" = var.num_workers } : {}
  )
}

# Resource for creating a Dataflow job from either a classic or a Flex template.
# This unified resource replaces the deprecated `google_dataflow_flex_template_job`.
# The resource is created conditionally based on whether the required template path is provided.
resource "google_dataflow_job" "main" {
  # The count meta-argument ensures that a job is only created if the appropriate template GCS path is specified.
  # This prevents plan-time validation errors when the module is used without the required inputs.
  count = local.can_create_job ? 1 : 0

  # The project ID where the Dataflow job will be created. If not specified, the provider project is used.
  project = var.project_id
  # A unique name for the Dataflow job.
  name = var.name
  # The region in which the Dataflow job will be executed.
  region = var.region
  # The zone in which the Dataflow job will be executed. Defaults to the region's default zone if not specified.
  zone = var.zone

  # The GCS path to the job template. For Flex Templates, this is the path to the container spec file.
  # For classic templates, it's the path to the classic template metadata file.
  template_gcs_path = var.use_flex_template ? var.container_spec_gcs_path : var.template_gcs_path

  # A GCS path for Dataflow to stage temporary job files.
  temp_gcs_location = var.temp_gcs_location
  # Key-value pairs to provide to the Dataflow job as parameters, including merged worker settings.
  parameters = local.job_parameters
  # Labels to apply to the job.
  labels = var.labels
  # Defines the behavior of the streaming job when the resource is destroyed. One of 'drain' or 'cancel'.
  on_delete = var.on_delete
  # The maximum number of workers to use for an autoscaling job.
  max_workers = var.max_workers
  # The machine type to use for the Dataflow workers.
  machine_type = var.machine_type
  # The service account email to run the job as.
  service_account_email = var.service_account_email
  # The VPC network to deploy the workers in.
  network = var.network
  # The VPC subnetwork to deploy the workers in.
  subnetwork = var.subnetwork
  # The IP configuration for the workers.
  ip_configuration = var.ip_configuration
  # The Cloud KMS key to use for this job.
  kms_key_name = var.kms_key_name
  # A list of experiments to enable for the job.
  additional_experiments = var.additional_experiments

  # The lifecycle block prevents Terraform from showing a perpetual diff due to the Dataflow service
  # updating the job's parameters.
  lifecycle {
    ignore_changes = [
      # Dataflow adds its own internal parameters after job creation (e.g., sdk_pipeline_options),
      # which would cause a perpetual diff if not ignored.
      parameters,
    ]
  }
}
