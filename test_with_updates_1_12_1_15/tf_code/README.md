# Google Cloud Dataflow Flex Template Job

This module handles the creation and management of a Google Cloud Dataflow job launched from a Flex Template.

Flex Templates allow you to package and run your own Dataflow pipelines by specifying a Docker image and a template specification file on Cloud Storage.

## Usage

Here is a basic example of how to use this module:

```hcl
module "dataflow_flex_job" {
  source              = "./" # Can also be a Git repository
  project_id          = "your-gcp-project-id"
  region              = "us-central1"
  name                = "my-dataflow-flex-job"
  template_gcs_path   = "gs://my-templates-bucket/specs/my-pipeline-spec.json"
  temp_gcs_location   = "gs://my-staging-bucket/temp"
  service_account_email = "dataflow-runner@your-gcp-project-id.iam.gserviceaccount.com"

  parameters = {
    inputSubscription = "projects/your-gcp-project-id/subscriptions/my-input-sub"
    outputTable     = "your-gcp-project-id:my_dataset.my_output_table"
  }

  labels = {
    environment = "dev"
    owner       = "data-team"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

### Terraform

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

### Google Cloud APIs

This module requires the following Google Cloud APIs to be enabled on the project:

-   Cloud Dataflow API: `dataflow.googleapis.com`
-   Compute Engine API: `compute.googleapis.com`
-   Cloud Storage API: `storage.googleapis.com`
-   Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

### Service Account Permissions

The service account used to run the Dataflow job (`var.service_account_email`) requires the following roles:

-   `roles/dataflow.worker`: To run the Dataflow job.
-   `roles/storage.objectAdmin`: On the GCS buckets used for `template_gcs_path` and `temp_gcs_location`.
-   Additional roles may be required depending on the sources and sinks your pipeline interacts with (e.g., `roles/pubsub.subscriber`, `roles/bigquery.dataEditor`).

The identity or service account running Terraform requires permissions to create and manage Dataflow jobs, such as `roles/dataflow.admin`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_experiments"></a> [additional\_experiments](#input\_additional\_experiments) | List of experiments to enable on the Dataflow job. | `list(string)` | `[]` | no |
| <a name="input_enable_streaming_engine"></a> [enable\_streaming\_engine](#input\_enable\_streaming\_engine) | Enable/disable the Dataflow Streaming Engine for streaming jobs. | `bool` | `false` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | The configuration for VM IPs. Can be 'WORKER\_IP\_PUBLIC' or 'WORKER\_IP\_PRIVATE'. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | User-defined labels for the job. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use for workers. If not set, the service will pick a default. | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers to use. If not set, the service will pick a default. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the Dataflow Flex Template job. | `string` | `"dataflow-flex-template-job-example"` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the job in. | `string` | `null` | no |
| <a name="input_on_delete"></a> [on\_delete](#input\_on\_delete) | Defines the behavior of the job when the resource is destroyed. One of 'drain' or 'cancel'. | `string` | `"cancel"` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | The parameters for the Flex Template. (e.g. { "inputSubscription":"projects/p/subscriptions/s", "outputTable":"p:d.t" }) | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where the Dataflow job will be created. If it is not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the Dataflow job will run. If it is not provided, the provider region is used. | `string` | `null` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The service account to run the job as. | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork to host the job in. Must be in the same region as the job. | `string` | `null` | no |
| <a name="input_temp_gcs_location"></a> [temp\_gcs\_location](#input\_temp\_gcs\_location) | A GCS path for temporary files and staging. This variable must be set to a valid GCS location. | `string` | `"gs://your-gcs-bucket-name/temp"` | yes |
| <a name="input_template_gcs_path"></a> [template\_gcs\_path](#input\_template\_gcs\_path) | The GCS path to the Dataflow job template spec file. This variable must be set to a valid GCS location. | `string` | `"gs://your-gcs-bucket-name/templates/template-spec.json"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_job_id"></a> [job\_id](#output\_job\_id) | The unique ID of the Dataflow job. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dataflow job. |
| <a name="output_state"></a> [state](#output\_state) | The current state of the Dataflow job. |
| <a name="output_type"></a> [type](#output\_type) | The type of the Dataflow job (e.g., JOB\_TYPE\_STREAMING, JOB\_TYPE\_BATCH). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
