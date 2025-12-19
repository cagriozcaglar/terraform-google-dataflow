# The `terraform` block is used to configure Terraform's behavior, including the required providers and their versions.
terraform {
  # Specifies the required version of Terraform to be used.
  required_version = ">= 1.3.0"

  # Defines the required providers for this module.
  required_providers {
    # The Google Cloud provider is required for managing GCP resources.
    google = {
      source  = "hashicorp/google"
      version = ">= 4.40.0"
    }
    # The Random provider is used to generate a unique suffix for the job name.
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
