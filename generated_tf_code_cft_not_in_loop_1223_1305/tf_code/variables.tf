# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# The variables.tf file defines all the input variables that can be configured for the module.
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
variable "additional_experiments" {
  description = "List of experiments to enable for the Dataflow job."
  type        = list(string)
  default     = []
}

variable "container_spec_gcs_path" {
  description = "The GCS path to the Flex Template container spec file. Required when `use_flex_template` is true."
  type        = string
  default     = null
}

variable "ip_configuration" {
  description = "The IP configuration for the workers. Valid values are `WORKER_IP_PUBLIC` or `WORKER_IP_PRIVATE`."
  type        = string
  default     = null
}

variable "kms_key_name" {
  description = "The Cloud KMS key to use for this job. The key must be provided in the full format of `projects/<project>/locations/<location>/keyRings/<keyring>/cryptoKeys/<key>`."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of key-value pairs to assign to the Dataflow job."
  type        = map(string)
  default     = {}
}

variable "machine_type" {
  description = "The machine type to use for the Dataflow workers (e.g., `n1-standard-1`)."
  type        = string
  default     = null
}

variable "max_workers" {
  description = "The maximum number of workers to use for an autoscaling job. This should not be used with `num_workers`."
  type        = number
  default     = null
}

variable "name" {
  description = "A unique name for the Dataflow job."
  type        = string
  default     = "dataflow-job"
}

variable "network" {
  description = "The VPC network to which the workers will be deployed. Must be in the same project and region as the job."
  type        = string
  default     = null
}

variable "num_workers" {
  description = "The initial number of workers to use for a fixed-size job. This should not be used with `max_workers`. This is passed as a `numWorkers` parameter to the job."
  type        = number
  default     = null
}

variable "on_delete" {
  description = "Defines the behavior of the streaming job when the resource is destroyed. Valid values are `drain` and `cancel`. `drain` is recommended for streaming jobs to prevent data loss."
  type        = string
  default     = "cancel"
}

variable "parameters" {
  description = "A map of key-value parameters to pass to the Dataflow job."
  type        = map(any)
  default     = {}
}

variable "project_id" {
  description = "The GCP project ID where the Dataflow job will be created. If not specified, the provider project is used."
  type        = string
  default     = null
}

variable "region" {
  description = "The region in which the Dataflow job will be executed."
  type        = string
  default     = "us-central1"
}

variable "service_account_email" {
  description = "The service account email to run the Dataflow job as. If not specified, the default Compute Engine service account will be used. This service account must have the 'roles/dataflow.worker' role and any other permissions required by the job."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The VPC subnetwork to which the workers will be deployed. Must be in the same project and region as the job. The subnetwork must be provided in the format `regions/REGION/subnetworks/SUBNETWORK`."
  type        = string
  default     = null
}

variable "temp_gcs_location" {
  description = "A GCS path for Dataflow to stage temporary job files. This is required for all template jobs and MUST be overridden with a path to a GCS bucket you own. The bucket must exist."
  type        = string
  default     = "gs://your-gcs-bucket-for-temp/temp"
}

variable "template_gcs_path" {
  description = "The GCS path to the classic Dataflow template. Required when `use_flex_template` is false."
  type        = string
  default     = null
}

variable "use_flex_template" {
  description = "Set to true to create a Dataflow job from a Flex Template. If false, a classic template job is created."
  type        = bool
  default     = false
}

variable "zone" {
  description = "The zone in which the Dataflow job will be executed. If not specified, the service will pick a default zone in the region."
  type        = string
  default     = null
}
