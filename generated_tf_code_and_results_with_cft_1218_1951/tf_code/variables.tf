# This variable block defines the GCP project ID where the Dataflow job will be deployed.
variable "project_id" {
  description = "The ID of the Google Cloud project in which to launch the Dataflow job. If not provided, the provider project is used."
  type        = string
  default     = null
}

# This variable block defines the base name for the Dataflow job. A unique suffix will be appended.
variable "name" {
  description = "A unique name for the Dataflow job, which must start with a letter and contain only letters, numbers, and hyphens. A random suffix will be appended. If not provided, no job will be created."
  type        = string
  default     = null
}

# This variable block defines the GCP region for the Dataflow job.
variable "region" {
  description = "The region in which the Dataflow job will be launched."
  type        = string
  default     = "us-central1"
}

# This variable block defines the GCS path for a classic or Flex Dataflow template.
variable "template_gcs_path" {
  description = "The GCS path to the Dataflow job template. For classic templates, this is the path to the template file. For Flex Templates, this is the path to the template spec file. If not provided, no job will be created."
  type        = string
  default     = null
}

# This variable block defines the GCS location for temporary files.
variable "temp_gcs_location" {
  description = "A GCS path for Dataflow to stage temporary job files during the execution of the pipeline. If not provided, no job will be created."
  type        = string
  default     = null
}

# This variable block defines the parameters for the Dataflow job pipeline.
variable "parameters" {
  description = "Key/value pairs to pass to the Dataflow job as pipeline parameters. For Flex Templates, this map must contain 'containerSpecGcsPath'."
  type        = map(string)
  default     = {}
}

# This variable block defines the service account for the Dataflow worker VMs.
variable "service_account_email" {
  description = "The email of the service account to run the Dataflow job and workers. If unspecified, the default Compute Engine service account is used."
  type        = string
  default     = null
}

# This variable block defines the behavior when the Terraform resource is destroyed.
variable "on_delete" {
  description = "Action to take when the job resource is destroyed. Should be 'cancel' for streaming jobs and 'drain' for batch jobs."
  type        = string
  default     = "drain"
  validation {
    condition     = contains(["cancel", "drain"], var.on_delete)
    error_message = "The on_delete value must be either 'cancel' or 'drain'."
  }
}

# This variable block defines the GCP zone for the Dataflow job.
variable "zone" {
  description = "The zone in which the Dataflow job will be launched. If left blank, the service will pick a zone in the region."
  type        = string
  default     = null
}

# This variable block defines the machine type for the Dataflow workers.
variable "machine_type" {
  description = "The machine type to use for the Dataflow workers."
  type        = string
  default     = null
}

# This variable block defines the maximum number of workers for autoscaling.
variable "max_workers" {
  description = "The maximum number of workers to use for the job. This is a recommendation, not a strict limit."
  type        = number
  default     = null
}

# This variable block defines the network for the Dataflow workers.
variable "network" {
  description = "The VPC network to which the Dataflow workers will be assigned. If left blank, the default network is used."
  type        = string
  default     = null
}

# This variable block defines the subnetwork for the Dataflow workers.
variable "subnetwork" {
  description = "The VPC subnetwork to which the Dataflow workers will be assigned."
  type        = string
  default     = null
}

# This variable block defines the IP configuration for the workers.
variable "ip_configuration" {
  description = "The IP configuration for the Dataflow workers. Valid values are 'WORKER_IP_PUBLIC' and 'WORKER_IP_PRIVATE'."
  type        = string
  default     = null
  validation {
    # This condition ensures that if a value is provided, it's one of the allowed ones.
    # The ternary operator prevents the 'contains' function from being called with a null value, which would cause an error.
    condition     = var.ip_configuration == null ? true : contains(["WORKER_IP_PUBLIC", "WORKER_IP_PRIVATE"], var.ip_configuration)
    error_message = "The ip_configuration value must be one of 'WORKER_IP_PUBLIC', 'WORKER_IP_PRIVATE', or null."
  }
}

# This variable block defines whether to enable the Streaming Engine feature.
variable "enable_streaming_engine" {
  description = "Whether to enable Streaming Engine for the job."
  type        = bool
  default     = false
}

# This variable block defines additional experiments to enable.
variable "additional_experiments" {
  description = "List of experiments to enable for this job."
  type        = list(string)
  default     = []
}

# This variable block defines labels to apply to the Dataflow job.
variable "labels" {
  description = "A map of key/value label pairs to assign to the Dataflow job."
  type        = map(string)
  default     = {}
}

# This variable block defines the KMS key for encrypting job state.
variable "kms_key_name" {
  description = "The Cloud KMS key to use for this job. The key must be provided in the format 'projects/PROJECT/locations/LOCATION/keyRings/RING/cryptoKeys/KEY'."
  type        = string
  default     = null
}
