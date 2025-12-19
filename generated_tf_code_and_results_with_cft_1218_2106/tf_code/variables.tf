variable "project_id" {
  description = "The ID of the GCP project where the Dataflow job will be created. If not provided, no job will be created."
  type        = string
  default     = null
}

variable "name" {
  description = "A unique name for the Dataflow job. If not provided, no job will be created."
  type        = string
  default     = null
}

variable "template_gcs_path" {
  description = "The Google Cloud Storage path to the Dataflow template. For Flex templates, this is the path to the template JSON file. For Classic templates, this is the path to the template file. If not provided, no job will be created."
  type        = string
  default     = null
}

variable "temp_gcs_location" {
  description = "The Google Cloud Storage path for Dataflow to stage temporary files. Required when using a Classic template (i.e., when `var.flex_template` is `false`)."
  type        = string
  default     = null
}

variable "region" {
  description = "The GCP region where the Dataflow job will run."
  type        = string
  default     = "us-central1"
}

variable "flex_template" {
  description = "Set to true to use a Flex Template (`google_dataflow_flex_template_job`), or false to use a Classic Template (`google_dataflow_job`)."
  type        = bool
  default     = true
}

variable "parameters" {
  description = "A map of key-value parameters to pass to the Dataflow job."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "A map of key-value labels to apply to the Dataflow job."
  type        = map(string)
  default     = {}
}

variable "on_delete" {
  description = "Defines the behavior when the Dataflow job is deleted. For streaming jobs, 'drain' is recommended. For batch jobs, 'cancel' is a safe default. Valid values are 'drain', 'cancel', or 'disable' (for classic jobs only)."
  type        = string
  default     = "cancel"
}

variable "service_account_email" {
  description = "The email address of the service account to run the Dataflow job's workers as."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The fully-qualified URL of the VPC subnetwork to run the Dataflow job's workers in. The subnetwork must be in the same region as the job."
  type        = string
  default     = null
}

variable "ip_configuration" {
  description = "The IP configuration for the Dataflow workers. Valid values are 'WORKER_IP_PUBLIC' and 'WORKER_IP_PRIVATE'."
  type        = string
  default     = null
}

variable "machine_type" {
  description = "The machine type to use for the Dataflow workers. For example, 'n1-standard-1'."
  type        = string
  default     = null
}

variable "max_workers" {
  description = "The maximum number of workers to use for the Dataflow job. This enables autoscaling."
  type        = number
  default     = null
}

variable "enable_streaming_engine" {
  description = "Set to true to enable the Dataflow Streaming Engine for streaming jobs."
  type        = bool
  default     = false
}

variable "additional_experiments" {
  description = "A list of additional experiments to enable for the Dataflow job."
  type        = list(string)
  default     = []
}

variable "skip_wait_on_job_termination" {
  description = "If set to true, Terraform will not wait for the job to terminate upon 'terraform destroy'. This is only applicable for Flex Template jobs."
  type        = bool
  default     = false
}
