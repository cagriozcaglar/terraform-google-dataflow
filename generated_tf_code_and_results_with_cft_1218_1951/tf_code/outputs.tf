# The `output` block exposes the unique ID of the created Dataflow job.
output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = local.create_job ? google_dataflow_job.main[0].id : null
}

# The `output` block exposes the full name of the Dataflow job, including the random suffix.
output "job_name" {
  description = "The full name of the Dataflow job."
  value       = local.create_job ? google_dataflow_job.main[0].name : null
}

# The `output` block exposes the current state of the Dataflow job.
output "job_state" {
  description = "The current state of the Dataflow job."
  value       = local.create_job ? google_dataflow_job.main[0].state : null
}

# The `output` block exposes the type of the Dataflow job (e.g., 'JOB_TYPE_STREAMING').
output "job_type" {
  description = "The type of the Dataflow job."
  value       = local.create_job ? google_dataflow_job.main[0].type : null
}
