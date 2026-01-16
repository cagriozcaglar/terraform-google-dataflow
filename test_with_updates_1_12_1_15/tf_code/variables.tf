variable "additional_experiments" {
  description = "List of experiments to enable on the Dataflow job."
  type        = list(string)
  default     = []
}

variable "enable_streaming_engine" {
  description = "Enable/disable the Dataflow Streaming Engine for streaming jobs."
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "The configuration for VM IPs. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'."
  type        = string
  default     = null

  validation {
    condition     = var.ip_configuration == null ? true : contains(["WORKER_IP_PUBLIC", "WORKER_IP_PRIVATE"], var.ip_configuration)
    error_message = "The ip_configuration value must be one of 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'."
  }
}

variable "labels" {
  description = "User-defined labels for the job."
  type        = map(string)
  default     = {}
}

variable "machine_type" {
  description = "The machine type to use for workers. If not set, the service will pick a default."
  type        = string
  default     = null
}

variable "max_workers" {
  description = "The maximum number of workers to use. If not set, the service will pick a default."
  type        = number
  default     = null
}

variable "name" {
  description = "A unique name for the Dataflow Flex Template job."
  type        = string
  default     = "dataflow-flex-template-job-example"
}

variable "network" {
  description = "The VPC network to host the job in."
  type        = string
  default     = null
}

variable "on_delete" {
  description = "Defines the behavior of the job when the resource is destroyed. One of 'drain' or 'cancel'."
  type        = string
  default     = "cancel"

  validation {
    condition     = contains(["drain", "cancel"], var.on_delete)
    error_message = "The on_delete value must be one of 'drain' or 'cancel'."
  }
}

variable "parameters" {
  description = "The parameters for the Flex Template. (e.g. { \"inputSubscription\":\"projects/p/subscriptions/s\", \"outputTable\":\"p:d.t\" })"
  type        = map(string)
  default     = {}
}

variable "project_id" {
  description = "The GCP project ID where the Dataflow job will be created. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "region" {
  description = "The region in which the Dataflow job will run. If it is not provided, the provider region is used."
  type        = string
  default     = null
}

variable "service_account_email" {
  description = "The service account to run the job as."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork to host the job in. Must be in the same region as the job."
  type        = string
  default     = null
}

variable "temp_gcs_location" {
  description = "A GCS path for temporary files and staging. This variable must be set to a valid GCS location."
  type        = string
  default     = "gs://your-gcs-bucket-name/temp"
}

variable "template_gcs_path" {
  description = "The GCS path to the Dataflow job template spec file. This variable must be set to a valid GCS location."
  type        = string
  default     = "gs://your-gcs-bucket-name/templates/template-spec.json"
}
