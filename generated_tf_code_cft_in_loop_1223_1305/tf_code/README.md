# Terraform Google Cloud Dataflow Module

This module manages a Google Cloud Dataflow job, providing a standardized way to launch and configure batch or streaming pipelines from either a classic template or a Flex Template.

It optionally handles the creation of a dedicated service account for the job, automatically configuring the necessary IAM permissions for Dataflow and Google Cloud Storage access, following the principle of least privilege.

## Compatibility

This module is meant for use with Terraform version 1.3+ and has been tested with the `hashicorp/google` provider version `~> 4.38.0`.

## Usage

Below are examples of how to use the module to create a classic template job and a Flex Template job.

### Classic Template Job

This example launches a classic Word Count template job provided by Google.

```hcl
module "dataflow_classic_job" {
  source = "./" # Or a Git repository source

  project_id        = "your-gcp-project-id"
  region            = "us-central1"
  name              = "my-classic-wordcount-job"
  template_gcs_path = "gs://dataflow-templates-us-central1/latest/Word_Count"
  temp_gcs_location = "gs://your-bucket-for-temp-files/temp"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-bucket-for-output/wordcount"
  }

  labels = {
    environment = "dev"
    pipeline    = "wordcount"
  }
}
```

### Flex Template Job with a Dedicated Service Account

This example launches a job from a Flex Template and creates a new, dedicated service account with the correct permissions for the job to run.

```hcl
module "dataflow_flex_job" {
  source = "./" # Or a Git repository source

  project_id                = "your-gcp-project-id"
  region                    = "us-central1"
  name                      = "my-flex-streaming-job"
  use_flex_template         = true
  container_spec_gcs_path   = "gs://your-flex-template-bucket/spec.json"
  
  # Create a dedicated service account for this job
  create_service_account    = true
  service_account_name      = "df-flex-streaming-runner"

  parameters = {
    input_topic  = "projects/your-gcp-project-id/topics/my-input-topic"
    output_table = "your-gcp-project-id:my_dataset.my_table"
  }

  # Network configuration
  network    = "projects/your-gcp-project-id/global/networks/my-vpc-network"
  subnetwork = "regions/us-central1/subnetworks/my-dataflow-subnet"
  ip_configuration = "WORKER_IP_PRIVATE"

  # Streaming Engine is useful for streaming pipelines
  enable_streaming_engine = true
}
```

## Requirements

Before this module can be used on a project, the following APIs must be enabled:
-   Dataflow API: `dataflow.googleapis.com`
-   Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
-   IAM API: `iam.googleapis.com`
-   Compute Engine API: `compute.googleapis.com`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | A unique name for the Dataflow job. Must be unique within the project and region. If null, no job is created. | `string` | `null` | yes |
| project\_id | The Google Cloud project ID to deploy the Dataflow job into. If null, no job is created. | `string` | `null` | yes |
| region | The GCP region to run the Dataflow job in. | `string` | `"us-central1"` | no |
| additional\_experiments | A list of additional experiments to enable for the Dataflow job. | `list(string)` | `[]` | no |
| container\_spec\_gcs\_path | The GCS path to the Flex Template JSON spec file. Required if `use_flex_template` is true. | `string` | `null` | no |
| create\_service\_account | If true, a new service account is created for the Dataflow job. If false, the job uses the service account specified in 'service\_account\_email', or the default Compute Engine service account if that is empty. | `bool` | `false` | no |
| enable\_streaming\_engine | Enable Streaming Engine for streaming jobs. | `bool` | `null` | no |
| ip\_configuration | The IP configuration for the Dataflow workers. Can be 'WORKER\_IP\_PUBLIC' or 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| labels | A map of key-value labels to apply to the Dataflow job. | `map(string)` | `{}` | no |
| machine\_type | The machine type to use for the Dataflow workers (e.g., n1-standard-1). If not set, the service default will be used. | `string` | `null` | no |
| max\_workers | The maximum number of workers to use for the Dataflow job. If not set, the service default will be used. | `number` | `null` | no |
| network | The VPC network to which the Dataflow workers will be attached. Should be of the form 'projects/PROJECT/global/networks/NETWORK'. If not specified, the default network will be used. | `string` | `null` | no |
| on\_delete | Action to take when the Terraform resource is destroyed. Can be 'cancel' or 'drain'. | `string` | `"cancel"` | no |
| parameters | A map of key-value parameters to pass to the Dataflow job. | `map(string)` | `{}` | no |
| service\_account\_email | The email of the service account for the Dataflow job to run as. Ignored if 'create\_service\_account' is true. If empty, the default Compute Engine service account is used. | `string` | `null` | no |
| service\_account\_name | The name for the service account to be created (the part of the email before the '@'). Required if 'create\_service\_account' is true. | `string` | `null` | no |
| skip\_wait\_on\_job\_termination | If set to true, Terraform will not wait for the Flex Template job to finish before considering the resource created. Applies only to flex template jobs. | `bool` | `false` | no |
| subnetwork | The VPC subnetwork to which the Dataflow workers will be attached. Should be of the form 'regions/REGION/subnetworks/SUBNETWORK'. | `string` | `null` | no |
| temp\_gcs\_location | A GCS path for Dataflow to stage temporary job files, e.g., 'gs://your-bucket/temp'. Required for classic template jobs. | `string` | `null` | no |
| template\_gcs\_path | The GCS path to the classic Dataflow template. Required if `use_flex_template` is false. | `string` | `null` | no |
| use\_flex\_template | Set to true to create a job from a Flex Template. If false, a classic template job is created. | `bool` | `false` | no |
| zone | The GCP zone to run the Dataflow job in. If null, the service will pick a zone in the specified region. Applies only to classic template jobs. | `string` | `null` | no |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| created\_service\_account\_email | The email of the service account created by this module for the Dataflow job, if any. | `string` |
| job\_id | The unique ID of the created Dataflow job. | `string` |
| job\_name | The name of the Dataflow job. | `string` |
| job\_state | The current state of the Dataflow job. | `string` |
| job\_type | The type of the Dataflow job. | `string` |
