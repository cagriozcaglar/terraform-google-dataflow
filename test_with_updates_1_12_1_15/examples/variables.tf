variable "project_id" {
  description = "The Google Cloud project ID to deploy the example resources."
  type        = string
}

variable "region" {
  description = "The Google Cloud region to deploy the example resources."
  type        = string
  default     = "us-central1"
}
