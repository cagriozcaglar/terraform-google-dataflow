# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# The versions.tf file specifies the Terraform version and the providers required by the module.
terraform {
  # Specifies the required Terraform version.
  required_version = ">= 1.3"
  # Defines the required providers for this module.
  required_providers {
    google = {
      source = "hashicorp/google"
      # Bumping the provider version to ensure support for the unified google_dataflow_job resource,
      # which now handles both classic and Flex Templates, resolving previous validation failures.
      version = "~> 5.20"
    }
  }
}
