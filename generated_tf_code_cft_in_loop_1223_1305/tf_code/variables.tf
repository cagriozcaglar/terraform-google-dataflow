# This variable allows enabling additional experiments for the Dataflow job.
variable "additional_experiments" {
  description = "A list of additional experiments to enable for the Dataflow job."
  type        = list(string)
  default     = []
}

# This variable defines the GCS path to the Flex Template spec file.
variable "container_spec_gcs_path" {
  description = "The GCS path to the Flex Template JSON spec file. Required if use_flex_template is true."
  type        = string
  default     = null
  validation {
    condition     = var.container_spec_gcs_path == null ? true : substr(var.container_spec_gcs_path, 0, 5) == "gs://"
    error_message = "The container_spec_gcs_path must be a valid GCS path, starting with 'gs://'."
  }
}

# This variable controls whether a dedicated service account is created for the job.
variable "create_service_account" {
  description = "If true, a new service account is created for the Dataflow job. If false, the job uses the service account specified in 'service_account_email', or the default Compute Engine service account if that is empty."
  type        = bool
  default     = false
}

# This variable controls whether to enable the Dataflow Streaming Engine feature.
variable "enable_streaming_engine" {
  description = "Enable Streaming Engine for streaming jobs."
  type        = bool
  default     = null
}

# This variable controls the IP configuration for the Dataflow workers.
variable "ip_configuration" {
  description = "The IP configuration for the Dataflow workers. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'."
  type        = string
  default     = null
  validation {
    condition     = var.ip_configuration == null ? true : contains(["WORKER_IP_PUBLIC", "WORKER_IP_PRIVATE"], var.ip_configuration)
    error_message = "The ip_configuration must be one of 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'."
  }
}

# This variable allows applying labels to the Dataflow job.
variable "labels" {
  description = "A map of key-value labels to apply to the Dataflow job."
  type        = map(string)
  default     = {}
}

# This variable defines the machine type for the Dataflow workers.
variable "machine_type" {
  description = "The machine type to use for the Dataflow workers (e.g., n1-standard-1). If not set, the service default will be used."
  type        = string
  default     = null
}

# This variable sets the maximum number of workers for the Dataflow job.
variable "max_workers" {
  description = "The maximum number of workers to use for the Dataflow job. If not set, the service default will be used."
  type        = number
  default     = null
}

# This variable specifies a unique name for the Dataflow job.
variable "name" {
  description = "A unique name for the Dataflow job. Must be unique within the project and region. If null, no job is created."
  type        = string
  default     = null
}

# This variable specifies the VPC network for the Dataflow workers.
variable "network" {
  description = "The VPC network to which the Dataflow workers will be attached. Should be of the form 'projects/PROJECT/global/networks/NETWORK'. If not specified, the default network will be used."
  type        = string
  default     = null
}

# This variable defines the action to take when the Terraform resource is destroyed.
variable "on_delete" {
  description = "Action to take when the Terraform resource is destroyed. Can be 'cancel' or 'drain'."
  type        = string
  default     = "cancel"
  validation {
    condition     = contains(["cancel", "drain"], var.on_delete)
    error_message = "The on_delete variable must be one of 'cancel' or 'drain'."
  }
}

# This variable allows passing a map of parameters to the Dataflow job.
variable "parameters" {
  description = "A map of key-value parameters to pass to the Dataflow job."
  type        = map(string)
  default     = {}
}

# This variable defines the Google Cloud project ID where the Dataflow job will be created.
variable "project_id" {
  description = "The Google Cloud project ID to deploy the Dataflow job into. If null, no job is created."
  type        = string
  default     = null
}

# This variable specifies the GCP region where the Dataflow job will run.
variable "region" {
  description = "The GCP region to run the Dataflow job in."
  type        = string
  default     = "us-central1"
}

# This variable specifies the service account email for the Dataflow job to run as.
variable "service_account_email" {
  description = "The email of the service account for the Dataflow job to run as. Ignored if 'create_service_account' is true. If empty, the default Compute Engine service account is used."
  type        = string
  default     = null
}

# This variable specifies the name for the service account to be created.
variable "service_account_name" {
  description = "The name for the service account to be created (the part of the email before the '@'). Required if 'create_service_account' is true."
  type        = string
  default     = null
}

# This variable controls whether Terraform should wait for the Flex Template job to terminate upon creation.
variable "skip_wait_on_job_termination" {
  description = "If set to true, Terraform will not wait for the Flex Template job to finish before considering the resource created. Applies only to flex template jobs."
  type        = bool
  default     = false
}

# This variable specifies the VPC subnetwork for the Dataflow workers.
variable "subnetwork" {
  description = "The VPC subnetwork to which the Dataflow workers will be attached. Should be of the form 'regions/REGION/subnetworks/SUBNETWORK'."
  type        = string
  default     = null
}

# This variable specifies the GCS path for Dataflow to stage temporary job files.
variable "temp_gcs_location" {
  description = "A GCS path for Dataflow to stage temporary job files, e.g., 'gs://your-bucket/temp'. Required for classic template jobs."
  type        = string
  default     = null
  validation {
    condition     = var.temp_gcs_location == null ? true : substr(var.temp_gcs_location, 0, 5) == "gs://"
    error_message = "The temp_gcs_location must be a valid GCS path, starting with 'gs://'."
  }
}

# This variable defines the GCS path to the classic Dataflow template.
variable "template_gcs_path" {
  description = "The GCS path to the classic Dataflow template. Required if use_flex_template is false."
  type        = string
  default     = null
  validation {
    condition     = var.template_gcs_path == null ? true : substr(var.template_gcs_path, 0, 5) == "gs://"
    error_message = "The template_gcs_path must be a valid GCS path, starting with 'gs://'."
  }
}

# This variable controls whether to create a Dataflow job from a classic template or a Flex template.
variable "use_flex_template" {
  description = "Set to true to create a job from a Flex Template. If false, a classic template job is created."
  type        = bool
  default     = false
}

# This variable specifies the GCP zone where the Dataflow job will run.
variable "zone" {
  description = "The GCP zone to run the Dataflow job in. If null, the service will pick a zone in the specified region. Applies only to classic template jobs."
  type        = string
  default     = null
}
