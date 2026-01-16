terraform {
  # This module is requires Terraform 1.3 and higher.
  required_version = ">= 1.3"

  required_providers {
    # This module requires the Google Provider.
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
