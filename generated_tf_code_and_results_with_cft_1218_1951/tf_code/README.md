# Google Cloud Dataflow Job Module

This module creates a Google Cloud Dataflow job from either a classic or a Flex Template. It is designed to be a flexible and reusable component for launching both batch and streaming pipelines.

To launch a Flex Template job, provide the GCS path to the template spec file in `template_gcs_path` and include the `containerSpecGcsPath` in the `parameters` map.

## Usage

### Basic Classic Batch Job

The following example creates a basic Dataflow batch job using a public Google-provided template.

```hcl
module "dataflow_word_count" {
  source              = "./"
  project_id          = "your-gcp-project-id"
  name                = "my-batch-wordcount-job"
  region              = "us-central1"
  template_gcs_path   = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location   = "gs://your-staging-bucket/tmp"
  on_delete           = "drain"

  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    output    = "gs://your-output-bucket/wordcount/output"
  }

  labels = {
    environment = "dev"
    job-type    = "batch"
  }
}
```

### Flex Template Streaming Job

The following example creates a Dataflow streaming job from a custom Flex Template. It specifies a service account, enables the Streaming Engine, and sets the `on_delete` behavior to `cancel`.

```hcl
module "dataflow_flex_streaming" {
  source                  = "./"
  project_id              = "your-gcp-project-id"
  name                    = "my-flex-streaming-job"
  region                  = "us-east1"
  zone                    = "us-east1-b"
  template_gcs_path       = "gs://your-flex-template-bucket/spec.json"
  temp_gcs_location       = "gs://your-staging-bucket/flex/tmp"
  service_account_email   = "dataflow-runner@your-gcp-project-id.iam.gserviceaccount.com"
  on_delete               = "cancel"
  enable_streaming_engine = true
  max_workers             = 10

  parameters = {
    containerSpecGcsPath = "gs://your-flex-template-bucket/image.json"
    input_subscription   = "projects/your-gcp-project-id/subscriptions/my-input-sub"
    output_table         = "your-gcp-project-id:my_dataset.my_table"
  }

  labels = {
    environment = "prod"
    job-type    = "streaming"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_experiments"></a> [additional\_experiments](#input\_additional\_experiments) | List of experiments to enable for this job. | `list(string)` | `[]` | no |
| <a name="input_enable_streaming_engine"></a> [enable\_streaming\_engine](#input\_enable\_streaming\_engine) | Whether to enable Streaming Engine for the job. | `bool` | `false` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The IP configuration for the Dataflow workers. Valid values are 'WORKER\_IP\_PUBLIC' and 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | The Cloud KMS key to use for this job. The key must be provided in the format 'projects/PROJECT/locations/LOCATION/keyRings/RING/cryptoKeys/KEY'. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of key/value label pairs to assign to the Dataflow job. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use for the Dataflow workers. | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers to use for the job. This is a recommendation, not a strict limit. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Dataflow job, which must start with a letter and contain only letters, numbers, and hyphens. A random suffix will be appended. If not provided, no job will be created. | `string` | `null` | yes |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to which the Dataflow workers will be assigned. If left blank, the default network is used. | `string` | `null` | no |
| <a name="input_on_delete"></a> [on\_delete](#input\_on\_delete) | Action to take when the job resource is destroyed. Should be 'cancel' for streaming jobs and 'drain' for batch jobs. | `string` | `"drain"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Key/value pairs to pass to the Dataflow job as pipeline parameters. For Flex Templates, this map must contain 'containerSpecGcsPath'. | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the Google Cloud project in which to launch the Dataflow job. If not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the Dataflow job will be launched. | `string` | `"us-central1"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The email of the service account to run the Dataflow job and workers. If unspecified, the default Compute Engine service account is used. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The VPC subnetwork to which the Dataflow workers will be assigned. | `string` | `null` | no |
| <a name="input_temp_gcs_location"></a> [temp\_gcs\_location](#input\_temp\_gcs\_location) | A GCS path for Dataflow to stage temporary job files during the execution of the pipeline. If not provided, no job will be created. | `string` | `null` | yes |
| <a name="input_template_gcs_path"></a> [template\_gcs\_path](#input\_template\_gcs\_path) | The GCS path to the Dataflow job template. For classic templates, this is the path to the template file. For Flex Templates, this is the path to the template spec file. If not provided, no job will be created. | `string` | `null` | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone in which the Dataflow job will be launched. If left blank, the service will pick a zone in the region. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_id"></a> [job\_id](#output\_job\_id) | The unique ID of the created Dataflow job. |
| <a name="output_job_name"></a> [job\_name](#output\_job\_name) | The full name of the Dataflow job. |
| <a name="output_job_state"></a> [job\_state](#output\_job\_state) | The current state of the Dataflow job. |
| <a name="output_job_type"></a> [job\_type](#output\_job\_type) | The type of the Dataflow job. |

## Requirements

### Terraform

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.40.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dataflow_job.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataflow_job) | resource |
| [random_id.job_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
