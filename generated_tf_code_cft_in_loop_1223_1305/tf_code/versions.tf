# The terraform block is used to configure aspects of Terraform itself.
# It includes settings for required Terraform version and provider versions.
terraform {
  # Specifies the minimum version of Terraform required to apply this configuration.
  required_version = ">= 1.3"

  # The required_providers block specifies the providers required by the current module.
  required_providers {
    # Specifies the Google Cloud provider.
    google = {
      # The source of the provider, in the format 'namespace/name'.
      source = "hashicorp/google"
      # The version constraint for the provider.
      version = "~> 4.38.0"
    }
    # Specifies the Google Cloud Beta provider.
    google-beta = {
      # The source of the provider, in the format 'namespace/name'.
      source = "hashicorp/google-beta"
      # The version constraint for the provider.
      version = "~> 4.38.0"
    }
  }
}
