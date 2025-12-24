# The outputs.tf file defines the values that will be exported by the module.
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = can(google_dataflow_job.main[0].job_id) ? google_dataflow_job.main[0].job_id : null
}

output "job_name" {
  description = "The name of the created Dataflow job."
  value       = can(google_dataflow_job.main[0].name) ? google_dataflow_job.main[0].name : null
}

output "job_state" {
  description = "The current state of the Dataflow job."
  value       = can(google_dataflow_job.main[0].state) ? google_dataflow_job.main[0].state : null
}

output "job_type" {
  description = "The type of the Dataflow job (e.g., JOB_TYPE_STREAMING, JOB_TYPE_BATCH)."
  value       = can(google_dataflow_job.main[0].type) ? google_dataflow_job.main[0].type : null
}
