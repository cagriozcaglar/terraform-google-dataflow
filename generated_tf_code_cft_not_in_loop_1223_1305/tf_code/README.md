# Terraform Google Dataflow Job Module

This module provides a standardized way to launch and manage Google Cloud Dataflow jobs from either classic or Flex Templates. It uses the unified `google_dataflow_job` resource, which is the recommended approach for creating Dataflow jobs with recent versions of the Google Provider.

The module simplifies job creation by exposing common configuration options like networking, machine types, service accounts, and job parameters. It conditionally creates a job based on whether a classic or Flex Template path is provided, ensuring a flexible and clean implementation.

## Usage

Below are examples of how to use this module to create a Dataflow job from both a classic template and a Flex Template.

### Classic Template Job

This example launches a classic batch WordCount job from a public template provided by Google.

```hcl
module "dataflow_classic_job" {
  source              = "<source of this module>"
  project_id          = "your-gcp-project-id"
  name                = "my-classic-wordcount-job"
  region              = "us-central1"
  template_gcs_path   = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location   = "gs://your-staging-bucket/temp"
  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-output-bucket/wordcount/output"
  }
}
```

### Flex Template Job

This example launches a streaming job from a custom Flex Template. It includes VPC networking and a custom service account.

```hcl
module "dataflow_flex_job" {
  source                  = "<source of this module>"
  project_id              = "your-gcp-project-id"
  name                    = "my-streaming-flex-job"
  region                  = "us-central1"
  use_flex_template       = true
  container_spec_gcs_path = "gs://your-flex-template-bucket/spec.json"
  temp_gcs_location       = "gs://your-staging-bucket/temp"
  service_account_email   = "dataflow-runner-sa@your-gcp-project-id.iam.gserviceaccount.com"
  network                 = "projects/your-gcp-project-id/global/networks/your-vpc-network"
  subnetwork              = "regions/us-central1/subnetworks/your-dataflow-subnet"
  on_delete               = "drain"
  max_workers             = 10
  parameters = {
    input_topic  = "projects/your-gcp-project-id/topics/input-topic"
    output_table = "your-gcp-project-id:dataset.table"
  }
  labels = {
    env      = "production"
    pipeline = "real-time-analytics"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_experiments | List of experiments to enable for the Dataflow job. | `list(string)` | `[]` | no |
| container\_spec\_gcs\_path | The GCS path to the Flex Template container spec file. Required when `use_flex_template` is true. | `string` | `null` | yes |
| ip\_configuration | The IP configuration for the workers. Valid values are `WORKER_IP_PUBLIC` or `WORKER_IP_PRIVATE`. | `string` | `null` | no |
| kms\_key\_name | The Cloud KMS key to use for this job. The key must be provided in the full format of `projects/<project>/locations/<location>/keyRings/<keyring>/cryptoKeys/<key>`. | `string` | `null` | no |
| labels | A map of key-value pairs to assign to the Dataflow job. | `map(string)` | `{}` | no |
| machine\_type | The machine type to use for the Dataflow workers (e.g., `n1-standard-1`). | `string` | `null` | no |
| max\_workers | The maximum number of workers to use for an autoscaling job. This should not be used with `num_workers`. | `number` | `null` | no |
| name | A unique name for the Dataflow job. | `string` | `"dataflow-job"` | no |
| network | The VPC network to which the workers will be deployed. Must be in the same project and region as the job. | `string` | `null` | no |
| num\_workers | The initial number of workers to use for a fixed-size job. This should not be used with `max_workers`. This is passed as a `numWorkers` parameter to the job. | `number` | `null` | no |
| on\_delete | Defines the behavior of the streaming job when the resource is destroyed. Valid values are `drain` and `cancel`. `drain` is recommended for streaming jobs to prevent data loss. | `string` | `"cancel"` | no |
| parameters | A map of key-value parameters to pass to the Dataflow job. | `map(any)` | `{}` | no |
| project\_id | The GCP project ID where the Dataflow job will be created. If not specified, the provider project is used. | `string` | `null` | no |
| region | The region in which the Dataflow job will be executed. | `string` | `"us-central1"` | no |
| service\_account\_email | The service account email to run the Dataflow job as. If not specified, the default Compute Engine service account will be used. This service account must have the 'roles/dataflow.worker' role and any other permissions required by the job. | `string` | `null` | no |
| subnetwork | The VPC subnetwork to which the workers will be deployed. Must be in the same project and region as the job. The subnetwork must be provided in the format `regions/REGION/subnetworks/SUBNETWORK`. | `string` | `null` | no |
| temp\_gcs\_location | A GCS path for Dataflow to stage temporary job files. This is required for all template jobs and MUST be overridden with a path to a GCS bucket you own. The bucket must exist. | `string` | `"gs://your-gcs-bucket-for-temp/temp"` | yes |
| template\_gcs\_path | The GCS path to the classic Dataflow template. Required when `use_flex_template` is false. | `string` | `null` | yes |
| use\_flex\_template | Set to true to create a Dataflow job from a Flex Template. If false, a classic template job is created. | `bool` | `false` | no |
| zone | The zone in which the Dataflow job will be executed. If not specified, the service will pick a default zone in the region. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| job\_id | The unique ID of the created Dataflow job. |
| job\_name | The name of the created Dataflow job. |
| job\_state | The current state of the Dataflow job. |
| job\_type | The type of the Dataflow job (e.g., JOB\_TYPE\_STREAMING, JOB\_TYPE\_BATCH). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

### Terraform Versions

This module has been tested and is compatible with Terraform `1.3` and newer.

### Terraform Providers

| Name | Version |
|------|---------|
| google | ~> 5.20 |

### APIs

The following APIs must be enabled on the project where the resources will be created:

-   **Dataflow API**: `dataflow.googleapis.com`
-   **Compute Engine API**: `compute.googleapis.com`
-   **Cloud Storage API**: `storage.googleapis.com`
-   **Cloud Resource Manager API**: `cloudresourcemanager.googleapis.com`
-   (Optional) **Cloud KMS API**: `cloudkms.googleapis.com` if using the `kms_key_name` variable.

### Roles

The service account or user running Terraform must have the following roles to provision the resources:

-   `roles/dataflow.developer`: To create and manage Dataflow jobs.
-   `roles/iam.serviceAccountUser`: To assign a service account to the Dataflow workers.

The **Dataflow worker service account** (specified via `service_account_email`) requires the following roles:

-   `roles/dataflow.worker`: Grants necessary permissions to execute Dataflow pipelines.
-   Additional roles may be required depending on the job's sources and sinks (e.g., `roles/pubsub.subscriber`, `roles/bigquery.dataEditor`, `roles/storage.objectAdmin`).
