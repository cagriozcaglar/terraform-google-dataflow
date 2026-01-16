# Simple Dataflow Flex Template Job Example

This example demonstrates how to use the Dataflow Flex Template module to create a Dataflow job.

The example will:
1.  Enable the required Google Cloud APIs (`dataflow`, `compute`, `storage`, `cloudresourcemanager`).
2.  Create a GCS bucket to be used for the Dataflow job's temporary files and to host the template specification file.
3.  Upload a sample Flex Template specification file to the GCS bucket. This sample uses a public Dataflow image that can run Beam SQL queries.
4.  Create a dedicated service account for the Dataflow job to use.
5.  Assign the necessary IAM roles (`roles/dataflow.worker`, `roles/storage.objectAdmin`) to the service account.
6.  Instantiate the root module to launch the Dataflow job using the created resources.

## How to use

1.  Clone the module repository and navigate to this example directory.
2.  Ensure you have authenticated with Google Cloud (`gcloud auth application-default login`).
3.  Create a `terraform.tfvars` file and provide the required `project_id`:
