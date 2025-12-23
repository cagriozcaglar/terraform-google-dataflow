# This output exposes the email of the service account created by this module.
output "created_service_account_email" {
  description = "The email of the service account created by this module for the Dataflow job, if any."
  value       = try(google_service_account.dataflow_runner[0].email, null)
}

# This output exposes the unique ID of the created Dataflow job.
output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = try(local.job.id, null)
}

# This output exposes the name of the Dataflow job.
output "job_name" {
  description = "The name of the Dataflow job."
  value       = try(local.job.name, null)
}

# This output exposes the current state of the Dataflow job.
output "job_state" {
  description = "The current state of the Dataflow job."
  value       = try(local.job.state, null)
}

# This output exposes the type of the Dataflow job (e.g., JOB_TYPE_BATCH, JOB_TYPE_STREAMING).
output "job_type" {
  description = "The type of the Dataflow job."
  value       = try(local.job.type, null)
}
