# Specifies the minimum required Terraform version and provider configurations.
terraform {
  # This module is compatible with Terraform version 1.3 and higher.
  required_version = ">= 1.3"
  required_providers {
    # The Google Cloud provider is required for managing Google Cloud resources.
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    # The random provider is required for generating a unique job name suffix.
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
