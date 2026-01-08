variable "additional_experiments" {
  description = "List of experiments to enable."
  type        = list(string)
  default     = []
}

variable "container_spec_gcs_path" {
  description = "The GCS path for the Dataflow Flex Template container spec. Required if `use_flex_template` is true."
  type        = string
  default     = null
}

variable "enable_streaming_engine" {
  description = "Enable Streaming Engine for streaming jobs. This is for classic templates. For Flex Templates, pass 'enableStreamingEngine=true' in parameters."
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "The configuration for worker IP address assignment. Can be `WORKER_IP_PUBLIC` or `WORKER_IP_PRIVATE`."
  type        = string
  default     = null
}

variable "kms_key_name" {
  description = "The KMS key used to encrypt the job resources."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of labels to assign to the Dataflow job."
  type        = map(string)
  default     = {}
}

variable "machine_type" {
  description = "The machine type to use for Dataflow workers. If not specified, the default is used."
  type        = string
  default     = null
}

variable "max_workers" {
  description = "The maximum number of workers to use for the job. Used for autoscaling. Cannot be used with `num_workers`."
  type        = number
  default     = null
}

variable "name" {
  description = "A unique name for the Dataflow job. Must be unique within the project and region. A default value is provided for module testability, but it should be overridden."
  type        = string
  default     = "dataflow-job-from-tf"
}

variable "network" {
  description = "The self-link of the VPC network to which the job's workers should be assigned."
  type        = string
  default     = null
}

variable "num_workers" {
  description = "The fixed number of workers to use for the job. This is passed as the `numWorkers` parameter to the job, and cannot be used with `max_workers`."
  type        = number
  default     = null
}

variable "on_delete" {
  description = "Action to take when the Terraform resource is destroyed. Can be 'drain', 'cancel' or 'terminate'."
  type        = string
  default     = "cancel"

  validation {
    condition     = contains(["drain", "cancel", "terminate"], var.on_delete)
    error_message = "The on_delete value must be one of 'drain', 'cancel', or 'terminate'."
  }
}

variable "parameters" {
  description = "Key/value pairs to be passed to the Dataflow job as runtime parameters."
  type        = map(string)
  default     = {}
}

variable "project_id" {
  description = "The project ID where the Dataflow job will be created. If not provided, the provider's project is used."
  type        = string
  default     = null
}

variable "region" {
  description = "The region where the Dataflow job will be created. If not provided, the provider's region is used. A default value is provided for module testability, but it should be overridden."
  type        = string
  default     = "us-central1"
}

variable "service_account_email" {
  description = "The service account to run the Dataflow job. If not specified, the default Compute Engine service account is used."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The self-link of the subnetwork to which the job's workers should be assigned."
  type        = string
  default     = null
}

variable "temp_gcs_location" {
  description = "A GCS path for the Dataflow service to stage temporary files. Must be a gs:// URL. A placeholder value is provided for module testability, but it must be overridden with a valid GCS path."
  type        = string
  default     = "gs://INVALID_BUCKET/temp"
}

variable "template_gcs_path" {
  description = "The GCS path for the classic Dataflow template. Required if `use_flex_template` is false. A placeholder value is provided for module testability, but it must be overridden with a valid template path."
  type        = string
  default     = "gs://INVALID_BUCKET/templates/template_name"
}

variable "use_flex_template" {
  description = "Set to true to launch a Dataflow Flex Template job. If false, a classic template job is launched."
  type        = bool
  default     = false
}

variable "zone" {
  description = "The zone where the Dataflow job will be created. It's recommended to leave this blank and let the service choose the zone."
  type        = string
  default     = null
}
