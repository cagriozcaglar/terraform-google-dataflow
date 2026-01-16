# This module is used to create a Google Cloud Dataflow job from a Flex Template.
# Flex Templates allow you to package and run your own Dataflow pipelines.
#
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
resource "google_dataflow_job" "dataflow_flex_template_job" {
  # The GCP project ID in which to run the Dataflow job. If not set, the provider's project is used.
  project = var.project_id
  # The region in which to run the Dataflow job. If not set, the provider's region is used.
  region = var.region
  # A unique name for the Dataflow job.
  name = var.name
  # The GCS path to the Dataflow job template. For Flex Templates, this is the path to the spec file.
  template_gcs_path = var.template_gcs_path
  # A GCS path for temporary files and staging.
  temp_gcs_location = var.temp_gcs_location
  # A list of experiments to enable.
  additional_experiments = var.additional_experiments
  # Set to true to enable the Dataflow Streaming Engine.
  enable_streaming_engine = var.enable_streaming_engine
  # Determines the IP address configuration for the workers.
  ip_configuration = var.ip_configuration
  # The labels to apply to the Dataflow job.
  labels = var.labels
  # The machine type to use for the workers.
  machine_type = var.machine_type
  # The maximum number of workers to use.
  max_workers = var.max_workers
  # The VPC network to host the job in.
  network = var.network
  # Defines the behavior of the job when the resource is destroyed. Can be 'drain' or 'cancel'.
  on_delete = var.on_delete
  # The parameters to pass to the Flex Template. This is a map of key/value pairs.
  parameters = var.parameters
  # The service account email to run the job as.
  service_account_email = var.service_account_email
  # The subnetwork to host the job in.
  subnetwork = var.subnetwork
}
