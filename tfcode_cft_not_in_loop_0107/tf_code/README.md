# Terraform Module for Google Cloud Dataflow Job

This module is used to create and manage Google Cloud Dataflow jobs. It supports both classic templates and Flex Templates by using the `google_dataflow_job` resource and toggling the `use_flex_template` variable.

The module encapsulates common configurations such as worker settings, networking, service accounts, and job parameters, providing a reusable interface for launching various Dataflow pipelines.

## Usage

### Classic Template Job

The following example demonstrates how to launch a classic Dataflow template job.

```hcl
module "dataflow_word_count" {
  source              = "./" # Replace with module source
  name                = "wordcount-classic-job"
  project_id          = "your-gcp-project-id"
  region              = "us-central1"
  template_gcs_path   = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location   = "gs://your-staging-bucket/temp"
  service_account_email = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"
  
  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-output-bucket/wordcount/outputs"
  }

  network    = "projects/your-gcp-project-id/global/networks/your-vpc-network"
  subnetwork = "regions/us-central1/subnetworks/your-vpc-subnetwork"
  
  labels = {
    environment = "dev"
    pipeline    = "wordcount"
  }
}
```

### Flex Template Job

The following example demonstrates how to launch a Dataflow Flex Template job. Note the use of `use_flex_template = true` and `container_spec_gcs_path`.

```hcl
module "dataflow_flex_job" {
  source                  = "./" # Replace with module source
  name                    = "my-flex-template-job"
  project_id              = "your-gcp-project-id"
  region                  = "us-central1"
  use_flex_template       = true
  container_spec_gcs_path = "gs://your-flex-template-bucket/spec.json"
  temp_gcs_location       = "gs://your-staging-bucket/temp"
  service_account_email   = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"
  
  parameters = {
    input_topic  = "projects/your-gcp-project-id/topics/my-input-topic"
    output_table = "your-gcp-project-id:my_dataset.my_table"
  }

  max_workers = 10
  machine_type = "n1-standard-2"
  
  labels = {
    environment = "prod"
    pipeline    = "streaming-etl"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following sections describe the requirements for using this module.

### Software

The following software is required:
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Terraform Provider for GCP][terraform-provider-gcp] >= 4.50.0

[terraform-provider-gcp]: https://github.com/hashicorp/terraform-provider-google

### Service Account

A service account with the following roles is required to provision the resources of this module:

- Dataflow Admin: `roles/dataflow.admin`
- Service Account User: `roles/iam.serviceAccountUser` (required if a custom `service_account_email` is specified for the job)

The [Project IAM Admin](https://cloud.google.com/iam/docs/understanding-roles#project-iam-roles) role is recommended to manage the necessary permissions.

### APIs

A project with the following APIs enabled is required:

- Dataflow API: `dataflow.googleapis.com`
- Compute Engine API: `compute.googleapis.com`
- Cloud Storage API: `storage.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Dataflow job. Must be unique within the project and region. | `string` | `"dataflow-job-from-tf"` | yes |
| <a name="input_temp_gcs_location"></a> [temp\_gcs\_location](#input\_temp\_gcs\_location) | A GCS path for the Dataflow service to stage temporary files. Must be a gs:// URL. | `string` | `"gs://INVALID_BUCKET/temp"` | yes |
| <a name="input_additional_experiments"></a> [additional\_experiments](#input\_additional\_experiments) | List of experiments to enable. | `list(string)` | `[]` | no |
| <a name="input_container_spec_gcs_path"></a> [container\_spec\_gcs\_path](#input\_container\_spec\_gcs\_path) | The GCS path for the Dataflow Flex Template container spec. Required if `use_flex_template` is true. | `string` | `null` | no |
| <a name="input_enable_streaming_engine"></a> [enable\_streaming\_engine](#input\_enable\_streaming\_engine) | Enable Streaming Engine for streaming jobs. This is for classic templates. For Flex Templates, pass 'enableStreamingEngine=true' in parameters. | `bool` | `false` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The configuration for worker IP address assignment. Can be `WORKER_IP_PUBLIC` or `WORKER_IP_PRIVATE`. | `string` | `null` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The KMS key used to encrypt the job resources. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to assign to the Dataflow job. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use for Dataflow workers. If not specified, the default is used. | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers to use for the job. Used for autoscaling. Cannot be used with `num_workers`. | `number` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The self-link of the VPC network to which the job's workers should be assigned. | `string` | `null` | no |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | The fixed number of workers to use for the job. This is passed as the `numWorkers` parameter to the job, and cannot be used with `max_workers`. | `number` | `null` | no |
| <a name="input_on_delete"></a> [on\_delete](#input\_on\_delete) | Action to take when the Terraform resource is destroyed. Can be 'drain', 'cancel' or 'terminate'. | `string` | `"cancel"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Key/value pairs to be passed to the Dataflow job as runtime parameters. | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID where the Dataflow job will be created. If not provided, the provider's project is used. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the Dataflow job will be created. If not provided, the provider's region is used. | `string` | `"us-central1"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The service account to run the Dataflow job. If not specified, the default Compute Engine service account is used. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The self-link of the subnetwork to which the job's workers should be assigned. | `string` | `null` | no |
| <a name="input_template_gcs_path"></a> [template\_gcs\_path](#input\_template\_gcs\_path) | The GCS path for the classic Dataflow template. Required if `use_flex_template` is false. | `string` | `"gs://INVALID_BUCKET/templates/template_name"` | no |
| <a name="input_use_flex_template"></a> [use\_flex\_template](#input\_use\_flex\_template) | Set to true to launch a Dataflow Flex Template job. If false, a classic template job is launched. | `bool` | `false` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone where the Dataflow job will be created. It's recommended to leave this blank and let the service choose the zone. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_id"></a> [job\_id](#output\_job\_id) | The unique ID of the created Dataflow job. |
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | The name of the created Dataflow job. |
| <a name="output_job_state"></a> [job\_state](#output\_job\_state) | The current state of the Dataflow job. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
