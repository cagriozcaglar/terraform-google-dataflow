terraform {
  # This block specifies the required Terraform version and provider versions.
  required_version = ">= 1.3"
  required_providers {
    google = {
      # The Google Cloud provider is used to manage GCP resources.
      source  = "hashicorp/google"
      version = ">= 4.40.0"
    }
    google-beta = {
      # The Google Cloud beta provider is used for features that are not yet generally available.
      source  = "hashicorp/google-beta"
      version = ">= 4.40.0"
    }
  }
}
