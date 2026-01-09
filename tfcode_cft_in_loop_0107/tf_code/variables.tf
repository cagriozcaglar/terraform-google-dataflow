# The name for the Dataflow job. A unique name will be generated if not provided.
variable "name" {
  description = "The name for the Dataflow job. A unique name will be generated if not provided."
  type        = string
  default     = null
}

# The GCP project ID where the job will run. If not provided, the provider project is used.
variable "project_id" {
  description = "The GCP project ID where the job will run. If not provided, the provider project is used."
  type        = string
  default     = null
}

# The region where the job will run. If not provided, the provider region is used.
variable "region" {
  description = "The region where the job will run. If not provided, the provider region is used."
  type        = string
  default     = null
}

# The zone where the job will run. Applicable only for CLASSIC jobs.
variable "zone" {
  description = "The zone where the job will run. Applicable only for CLASSIC jobs."
  type        = string
  default     = null
}

# The type of Dataflow job template. Must be either 'CLASSIC' or 'FLEX'.
variable "job_type" {
  description = "The type of Dataflow job template. Must be either 'CLASSIC' or 'FLEX'."
  type        = string
  default     = "CLASSIC"
  validation {
    condition     = contains(["CLASSIC", "FLEX"], var.job_type)
    error_message = "The value for job_type must be either 'CLASSIC' or 'FLEX'."
  }
}

# The GCS path to the CLASSIC template file. Required if job_type is 'CLASSIC'.
variable "template_gcs_path" {
  description = "The GCS path to the CLASSIC template file. Required if job_type is 'CLASSIC'."
  type        = string
  default     = null
}

# The GCS path to the Flex Template JSON file. Required if job_type is 'FLEX'.
variable "flex_template_gcs_path" {
  description = "The GCS path to the Flex Template JSON file. Required if job_type is 'FLEX'."
  type        = string
  default     = null
}

# The GCS path for staging temporary files. Required for CLASSIC jobs.
variable "temp_gcs_location" {
  description = "The GCS path for staging temporary files. Required for CLASSIC jobs."
  type        = string
  default     = null
}

# Key-value pairs to be passed to the job as parameters.
variable "parameters" {
  description = "Key-value pairs to be passed to the job as parameters."
  type        = map(string)
  default     = {}
}

# User-defined labels to apply to the job.
variable "labels" {
  description = "User-defined labels to apply to the job."
  type        = map(string)
  default     = {}
}

# The service account email to run the job as.
variable "service_account_email" {
  description = "The service account email to run the job as."
  type        = string
  default     = null
}

# The machine type to use for the worker VMs.
variable "machine_type" {
  description = "The machine type to use for the worker VMs."
  type        = string
  default     = null
}

# The maximum number of workers permitted to run.
variable "max_workers" {
  description = "The maximum number of workers permitted to run."
  type        = number
  default     = null
}

# The VPC network to which the workers will be deployed.
variable "network" {
  description = "The VPC network to which the workers will be deployed."
  type        = string
  default     = null
}

# The VPC subnetwork to which the workers will be deployed.
variable "subnetwork" {
  description = "The VPC subnetwork to which the workers will be deployed."
  type        = string
  default     = null
}

# The configuration for VM IPs. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'.
variable "ip_configuration" {
  description = "The configuration for VM IPs. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'."
  type        = string
  default     = null
}

# List of experiments to enable for the job. Applicable only for CLASSIC jobs.
variable "additional_experiments" {
  description = "List of experiments to enable for the job. Applicable only for CLASSIC jobs."
  type        = list(string)
  default     = []
}

# Indicates if the job should use the streaming engine feature.
variable "enable_streaming_engine" {
  description = "Indicates if the job should use the streaming engine feature."
  type        = bool
  default     = false
}

# Defines the behavior on resource destruction. Can be 'drain' or 'cancel'. Default is 'cancel'.
variable "on_delete" {
  description = "Defines the behavior on resource destruction. Can be 'drain' or 'cancel'. Default is 'cancel'."
  type        = string
  default     = "cancel"
}

# If true, Terraform will not wait for job termination on destroy/update.
variable "skip_wait_on_job_termination" {
  description = "If true, Terraform will not wait for job termination on destroy/update."
  type        = bool
  default     = false
}
