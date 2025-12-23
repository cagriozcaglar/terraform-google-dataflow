# The locals block is used to define local variables within the module.
locals {
  # Flag to determine if a job should be created, based on the presence of essential identifiers.
  create_job = var.name != null && var.project_id != null

  # Determines the service account email to be used for the Dataflow job.
  # It prioritizes the newly created service account, falls back to the user-provided one,
  # and lets Google Cloud use the default if neither is specified.
  job_service_account_email = var.create_service_account && local.create_job ? google_service_account.dataflow_runner[0].email : var.service_account_email

  # Extracts bucket names from GCS paths to grant specific IAM permissions.
  # Using regex is more robust than splitting the string.
  temp_bucket_name           = var.temp_gcs_location != null ? one(regex("gs://([^/]+)", var.temp_gcs_location)) : null
  template_bucket_name       = var.template_gcs_path != null ? one(regex("gs://([^/]+)", var.template_gcs_path)) : null
  container_spec_bucket_name = var.container_spec_gcs_path != null ? one(regex("gs://([^/]+)", var.container_spec_gcs_path)) : null

  # Creates a set of all unique buckets that the service account needs access to.
  all_required_buckets = toset(compact([
    local.temp_bucket_name,
    local.template_bucket_name,
    local.container_spec_bucket_name,
  ]))

  # Identifies buckets that require write access (for temporary files).
  write_buckets = toset(compact([
    local.temp_bucket_name,
  ]))

  # Identifies buckets that only require read access (for templates), by removing write buckets from the full list.
  read_only_buckets = setsubtract(local.all_required_buckets, local.write_buckets)

  # Consolidates the two potential job resources (classic and flex) into a single list.
  # Due to the 'count' logic in the resources, this list will contain at most one element.
  job_list = concat(
    google_dataflow_flex_template_job.flex,
    google_dataflow_job.classic
  )

  # This local variable holds the single created Dataflow job resource object,
  # regardless of whether it's a classic or flex template job.
  # It is null if no job was created.
  job = length(local.job_list) > 0 ? local.job_list[0] : null
}

# This check block validates that a name is provided for the service account if it's being created.
check "service_account_name_check" {
  # The condition is met if service account creation is disabled, or if a name is provided.
  assert {
    condition     = !var.create_service_account || var.service_account_name != null
    error_message = "If 'create_service_account' is true, a 'service_account_name' must be provided."
  }
}

# This check block validates that the required variables for a classic Dataflow template job are provided.
check "classic_template_vars" {
  # The condition is met if it's not a classic template job creation, or if the required GCS paths are specified.
  assert {
    condition     = var.use_flex_template || !local.create_job || (var.template_gcs_path != null && var.temp_gcs_location != null)
    error_message = "When creating a classic template job (use_flex_template = false), both 'template_gcs_path' and 'temp_gcs_location' variables must be specified."
  }
}

# This check block validates that the required variables for a Flex Template Dataflow job are provided.
check "flex_template_vars" {
  # The condition is met if it's not a Flex Template job creation, or if the required GCS path is specified.
  assert {
    condition     = !var.use_flex_template || !local.create_job || var.container_spec_gcs_path != null
    error_message = "When creating a Flex Template job (use_flex_template = true), the 'container_spec_gcs_path' variable must be specified."
  }
}

# Retrieves project data, including the project number needed for the Dataflow service agent.
# This data source is only read when a job and service account are being created to avoid unnecessary API calls.
data "google_project" "project" {
  # The number of instances to create. Creates one if a service account and job are being created, otherwise zero.
  count = var.create_service_account && local.create_job ? 1 : 0
  # The project ID to get data for.
  project_id = var.project_id
}

# Creates a dedicated service account for the Dataflow job.
# This resource is created only when 'var.create_service_account' is true and a job is being created.
resource "google_service_account" "dataflow_runner" {
  # The number of instances to create. Creates one if service account creation is enabled and a job is being created, otherwise zero.
  count = var.create_service_account && local.create_job ? 1 : 0

  # The project ID to create the service account in.
  project = var.project_id
  # The account ID for the service account. This is the part of the email before the '@'.
  account_id = var.service_account_name
  # A human-readable name for the service account.
  display_name = "Dataflow Runner for ${var.name}"
}

# Grants the Dataflow Worker role to the created service account at the project level.
# This role is necessary for the Dataflow service to manage workers on behalf of the job.
resource "google_project_iam_member" "dataflow_worker" {
  # The number of instances to create. Creates one if service account creation is enabled and a job is being created, otherwise zero.
  count = var.create_service_account && local.create_job ? 1 : 0

  # The project ID where the IAM binding will be created.
  project = var.project_id
  # The role to grant.
  role = "roles/dataflow.worker"
  # The member to grant the role to, specified as the service account's email.
  member = "serviceAccount:${google_service_account.dataflow_runner[0].email}"
}

# Allows the Dataflow service agent to impersonate the created service account.
# This is a requirement for the Dataflow service to be able to launch jobs using the specified service account.
resource "google_service_account_iam_member" "dataflow_service_agent_user" {
  # The number of instances to create. Creates one if service account creation is enabled and a job is being created, otherwise zero.
  count = var.create_service_account && local.create_job ? 1 : 0

  # The fully-qualified name of the service account to bind the IAM policy to.
  service_account_id = google_service_account.dataflow_runner[0].name
  # The role to grant. 'serviceAccountUser' allows a principal to impersonate the service account.
  role = "roles/iam.serviceAccountUser"
  # The member to grant the role to. This is the Dataflow service agent for the project.
  member = "serviceAccount:service-${data.google_project.project[0].number}@dataflow-service-producer-prod.iam.gserviceaccount.com"
}

# Grants read-only storage permissions to the created service account for template buckets.
# This follows the principle of least privilege, allowing the job to read templates and container specs without granting write access.
resource "google_storage_bucket_iam_member" "storage_reader_access" {
  # Creates an IAM binding for each unique read-only bucket required by the job, if service account creation is enabled.
  for_each = var.create_service_account && local.create_job ? local.read_only_buckets : toset([])

  # The GCS bucket to grant permissions on.
  bucket = each.key
  # The role to grant. 'objectViewer' allows reading objects and their metadata.
  role = "roles/storage.objectViewer"
  # The member to grant the role to, specified as the service account's email.
  member = "serviceAccount:${google_service_account.dataflow_runner[0].email}"
}

# Grants storage permissions to the created service account for the temporary files bucket.
# This allows the Dataflow job to stage and manage temporary files required for its execution.
# The 'objectAdmin' role is used as recommended by the official Dataflow documentation for staging locations.
resource "google_storage_bucket_iam_member" "storage_writer_access" {
  # Creates an IAM binding for each unique write-access bucket required by the job, if service account creation is enabled.
  for_each = var.create_service_account && local.create_job ? local.write_buckets : toset([])

  # The GCS bucket to grant permissions on.
  bucket = each.key
  # The role to grant. 'objectAdmin' provides full control over GCS objects, which is required for staging files.
  role = "roles/storage.objectAdmin"
  # The member to grant the role to, specified as the service account's email.
  member = "serviceAccount:${google_service_account.dataflow_runner[0].email}"
}

# Creates a Dataflow job from a classic template.
# This resource is created only when 'var.use_flex_template' is false and all required variables are set.
resource "google_dataflow_job" "classic" {
  # The number of instances to create. Creates one if it's a classic template job and creation is enabled, otherwise zero.
  count = !var.use_flex_template && local.create_job ? 1 : 0

  # The GCP project ID where the job will run.
  project = var.project_id
  # The region where the job will run.
  region = var.region
  # The zone where the job will run.
  zone = var.zone
  # A unique name for the job.
  name = var.name
  # The GCS path to the classic template.
  template_gcs_path = var.template_gcs_path
  # The GCS path for temporary files.
  temp_gcs_location = var.temp_gcs_location
  # Key-value parameters for the job.
  parameters = var.parameters
  # Labels for the job.
  labels = var.labels
  # The behavior when the resource is destroyed. Can be 'cancel' or 'drain'.
  on_delete = var.on_delete
  # The email of the service account to run the job as.
  service_account_email = local.job_service_account_email
  # The maximum number of workers.
  max_workers = var.max_workers
  # The machine type for workers.
  machine_type = var.machine_type
  # The VPC network for workers.
  network = var.network
  # The VPC subnetwork for workers.
  subnetwork = var.subnetwork
  # The IP configuration for workers. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'.
  ip_configuration = var.ip_configuration
  # A list of experiments to enable.
  additional_experiments = var.additional_experiments
  # Enables the Streaming Engine feature for streaming jobs.
  enable_streaming_engine = var.enable_streaming_engine

  # Explicitly depend on the IAM bindings for the service account to prevent
  # race conditions where the job starts before permissions are granted.
  depends_on = [
    google_project_iam_member.dataflow_worker,
    google_service_account_iam_member.dataflow_service_agent_user,
    google_storage_bucket_iam_member.storage_reader_access,
    google_storage_bucket_iam_member.storage_writer_access,
  ]
}

# Creates a Dataflow job from a Flex Template.
# This resource is created only when 'var.use_flex_template' is true and all required variables are set.
resource "google_dataflow_flex_template_job" "flex" {
  # The number of instances to create. Creates one if it's a flex template job and creation is enabled, otherwise zero.
  count = var.use_flex_template && local.create_job ? 1 : 0
  # The provider to use for this resource. The Flex Template job resource is managed through the beta provider.
  provider = google-beta

  # The GCP project ID where the job will run.
  project = var.project_id
  # The region where the job will run.
  region = var.region
  # A unique name for the job.
  name = var.name
  # The GCS path to the Flex Template spec file.
  container_spec_gcs_path = var.container_spec_gcs_path
  # Key-value parameters for the job.
  parameters = var.parameters
  # Labels for the job.
  labels = var.labels
  # The email of the service account to run the job as.
  service_account_email = local.job_service_account_email
  # If true, Terraform does not wait for the job to terminate.
  skip_wait_on_job_termination = var.skip_wait_on_job_termination
  # The behavior when the resource is destroyed. Can be 'cancel' or 'drain'.
  on_delete = var.on_delete
  # The maximum number of workers.
  max_workers = var.max_workers
  # The machine type for workers.
  machine_type = var.machine_type
  # The VPC network for workers.
  network = var.network
  # The VPC subnetwork for workers.
  subnetwork = var.subnetwork
  # The IP configuration for workers. Can be 'WORKER_IP_PUBLIC' or 'WORKER_IP_PRIVATE'.
  ip_configuration = var.ip_configuration
  # A list of experiments to enable.
  additional_experiments = var.additional_experiments
  # Enables the Streaming Engine feature for streaming jobs.
  enable_streaming_engine = var.enable_streaming_engine

  # Explicitly depend on the IAM bindings for the service account to prevent
  # race conditions where the job starts before permissions are granted.
  depends_on = [
    google_project_iam_member.dataflow_worker,
    google_service_account_iam_member.dataflow_service_agent_user,
    google_storage_bucket_iam_member.storage_reader_access,
    google_storage_bucket_iam_member.storage_writer_access,
  ]
}
