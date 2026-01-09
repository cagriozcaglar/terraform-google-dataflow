# Terraform Google Dataflow Job Module

This module simplifies the creation and management of a Google Cloud Dataflow job. It supports launching jobs from both Classic and Flex templates, providing a unified interface for various configuration options.

The module automatically generates a unique job name if one is not provided, ensuring that job submissions do not conflict.

## Usage

Below are examples of how to use this module to create both Classic and Flex Template Dataflow jobs.

### Classic Template Job

This example demonstrates how to create a Dataflow job from a standard Google-provided Word Count template.

```hcl
module "word_count_job" {
  source = "<path_to_module>"

  project_id          = "your-gcp-project-id"
  region              = "us-central1"
  name                = "my-classic-word-count"
  job_type            = "CLASSIC"
  template_gcs_path   = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location   = "gs://your-staging-bucket/temp/"
  service_account_email = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-staging-bucket/outputs/wordcount"
  }

  labels = {
    environment = "development"
    owner       = "data-eng"
  }
}
```

### Flex Template Job

This example shows how to launch a Dataflow job using a custom Flex Template.

```hcl
module "flex_template_job" {
  source = "<path_to_module>"

  project_id             = "your-gcp-project-id"
  region                 = "us-east1"
  name                   = "my-flex-template-job"
  job_type               = "FLEX"
  flex_template_gcs_path = "gs://your-flex-template-bucket/templates/my-template.json"
  service_account_email  = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"
  network                = "projects/your-gcp-project-id/global/networks/your-vpc-network"
  subnetwork             = "https://www.googleapis.com/compute/v1/projects/your-gcp-project-id/regions/us-east1/subnetworks/your-vpc-subnetwork"
  
  parameters = {
    input_topic  = "projects/your-gcp-project-id/topics/my-input-topic"
    output_table = "your-gcp-project-id:my_dataset.my_table"
  }

  labels = {
    environment = "production"
    team        = "analytics"
  }
}
```

## Requirements

Before this module can be used on a project, you must ensure that the following APIs are enabled:

-   Dataflow API: `dataflow.googleapis.com`
-   Cloud Storage API: `storage.googleapis.com`
-   Compute Engine API: `compute.googleapis.com`

### Terraform Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](https://registry.terraform.io/providers/hashicorp/google) | >= 5.0.0 |
| <a name="provider_random"></a> [random](https://registry.terraform.io/providers/hashicorp/random) | >= 3.0.0 |

### Terraform Version

This module is compatible with Terraform version `1.3` and higher.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_experiments"></a> [additional\_experiments](#input\_additional\_experiments) | List of experiments to enable for the job. Applicable only for CLASSIC jobs. | `list(string)` | `[]` | no |
| <a name="input_enable_streaming_engine"></a> [enable\_streaming\_engine](#input\_enable\_streaming\_engine) | Indicates if the job should use the streaming engine feature. | `bool` | `false` | no |
| <a name="input_flex_template_gcs_path"></a> [flex\_template\_gcs\_path](#input\_flex\_template\_gcs\_path) | The GCS path to the Flex Template JSON file. Required if job\_type is 'FLEX'. | `string` | `null` | yes |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The configuration for VM IPs. Can be 'WORKER\_IP\_PUBLIC' or 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| <a name="input_job_type"></a> [job\_type](#input\_job\_type) | The type of Dataflow job template. Must be either 'CLASSIC' or 'FLEX'. | `string` | `"CLASSIC"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | User-defined labels to apply to the job. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use for the worker VMs. | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers permitted to run. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name for the Dataflow job. A unique name will be generated if not provided. | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to which the workers will be deployed. | `string` | `null` | no |
| <a name="input_on_delete"></a> [on\_delete](#input\_on\_delete) | Defines the behavior on resource destruction. Can be 'drain' or 'cancel'. | `string` | `"cancel"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Key-value pairs to be passed to the job as parameters. | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where the job will run. If not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the job will run. If not provided, the provider region is used. | `string` | `null` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The service account email to run the job as. | `string` | `null` | no |
| <a name="input_skip_wait_on_job_termination"></a> [skip\_wait\_on\_job\_termination](#input\_skip\_wait\_on\_job\_termination) | If true, Terraform will not wait for job termination on destroy/update. | `bool` | `false` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The VPC subnetwork to which the workers will be deployed. | `string` | `null` | no |
| <a name="input_temp_gcs_location"></a> [temp\_gcs\_location](#input\_temp\_gcs\_location) | The GCS path for staging temporary files. Required for CLASSIC jobs. | `string` | `null` | yes |
| <a name="input_template_gcs_path"></a> [template\_gcs\_path](#input\_template\_gcs\_path) | The GCS path to the CLASSIC template file. Required if job\_type is 'CLASSIC'. | `string` | `null` | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone where the job will run. Applicable only for CLASSIC jobs. | `string` | `null` | no |

**Note:** `template_gcs_path` and `temp_gcs_location` are conditionally required when `job_type` is `CLASSIC`. `flex_template_gcs_path` is conditionally required when `job_type` is `FLEX`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_id"></a> [job\_id](#output\_job\_id) | The unique ID of the created Dataflow job. |
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | The unique name of the created Dataflow job. |
| <a name="output_job_state"></a> [job\_state](#output\_job\_state) | The current state of the created Dataflow job. |
| <a name="output_job_type"></a> [job\_type](#output\_job\_type) | The type of the created Dataflow job. |
