# Google Cloud Dataflow Job Module

This module is used to create and manage a Google Cloud Dataflow job. It supports both Classic templates (via `google_dataflow_job`) and Flex templates (via `google_dataflow_flex_template_job`).

## Usage

Below are examples of how to use the module.

### Flex Template Job (Default)

This is the default behavior (`flex_template = true`). The module will use the `google_dataflow_flex_template_job` resource.

```hcl
module "dataflow_job" {
  source              = "./" # Or path to this module
  project_id          = "your-gcp-project-id"
  name                = "my-dataflow-flex-job"
  region              = "us-central1"
  template_gcs_path   = "gs://dataflow-templates/latest/flex/Word_Count"
  service_account_email = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"
  
  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-gcs-bucket/wordcount/output"
  }

  labels = {
    env = "production"
  }
}
```

### Classic Template Job

To create a job from a Classic template, set `flex_template = false`. This will use the `google_dataflow_job` resource and requires `temp_gcs_location`.

```hcl
module "dataflow_job_classic" {
  source              = "./" # Or path to this module
  project_id          = "your-gcp-project-id"
  name                = "my-dataflow-classic-job"
  region              = "us-central1"
  flex_template       = false
  template_gcs_path   = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location   = "gs://your-gcs-bucket/temp"
  service_account_email = "your-runner-service-account@your-gcp-project-id.iam.gserviceaccount.com"
  
  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-gcs-bucket/wordcount/output"
  }

  labels = {
    env = "staging"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.40.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.40.0 |
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.40.0 |

## Resources

| Name | Type |
|------|------|
| [google_dataflow_flex_template_job.flex_template_job](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/dataflow_flex_template_job) | resource |
| [google_dataflow_job.classic_template_job](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataflow_job) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_experiments"></a> [additional\_experiments](#input\_additional\_experiments) | A list of additional experiments to enable for the Dataflow job. | `list(string)` | `[]` | no |
| <a name="input_enable_streaming_engine"></a> [enable\_streaming\_engine](#input\_enable\_streaming\_engine) | Set to true to enable the Dataflow Streaming Engine for streaming jobs. | `bool` | `false` | no |
| <a name="input_flex_template"></a> [flex\_template](#input\_flex\_template) | Set to true to use a Flex Template (`google_dataflow_flex_template_job`), or false to use a Classic Template (`google_dataflow_job`). | `bool` | `true` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The IP configuration for the Dataflow workers. Valid values are 'WORKER\_IP\_PUBLIC' and 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of key-value labels to apply to the Dataflow job. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use for the Dataflow workers. For example, 'n1-standard-1'. | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers to use for the Dataflow job. This enables autoscaling. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Dataflow job. If not provided, no job will be created. | `string` | `null` | yes |
| <a name="input_on_delete"></a> [on\_delete](#input\_on\_delete) | Defines the behavior when the Dataflow job is deleted. For streaming jobs, 'drain' is recommended. For batch jobs, 'cancel' is a safe default. Valid values are 'drain', 'cancel', or 'disable' (for classic jobs only). | `string` | `"cancel"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A map of key-value parameters to pass to the Dataflow job. | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the GCP project where the Dataflow job will be created. If not provided, no job will be created. | `string` | `null` | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where the Dataflow job will run. | `string` | `"us-central1"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The email address of the service account to run the Dataflow job's workers as. | `string` | `null` | no |
| <a name="input_skip_wait_on_job_termination"></a> [skip\_wait\_on\_job\_termination](#input\_skip\_wait\_on\_job\_termination) | If set to true, Terraform will not wait for the job to terminate upon 'terraform destroy'. This is only applicable for Flex Template jobs. | `bool` | `false` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The fully-qualified URL of the VPC subnetwork to run the Dataflow job's workers in. The subnetwork must be in the same region as the job. | `string` | `null` | no |
| <a name="input_temp_gcs_location"></a> [temp\_gcs\_location](#input\_temp\_gcs\_location) | The Google Cloud Storage path for Dataflow to stage temporary files. Required when using a Classic template (i.e., when `var.flex_template` is `false`). | `string` | `null` | no |
| <a name="input_template_gcs_path"></a> [template\_gcs\_path](#input\_template\_gcs\_path) | The Google Cloud Storage path to the Dataflow template. For Flex templates, this is the path to the template JSON file. For Classic templates, this is the path to the template file. If not provided, no job will be created. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_id"></a> [job\_id](#output\_job\_id) | The unique ID of the created Dataflow job. |
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | The name of the created Dataflow job. |
| <a name="output_job_state"></a> [job\_state](#output\_job\_state) | The current state of the Dataflow job. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
