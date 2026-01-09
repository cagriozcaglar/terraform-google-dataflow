# The unique ID of the created Dataflow job.
output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = google_dataflow_job.this.job_id
}

# The unique name of the created Dataflow job.
output "job_name" {
  description = "The unique name of the created Dataflow job."
  value       = google_dataflow_job.this.name
}

# The current state of the created Dataflow job.
output "job_state" {
  description = "The current state of the created Dataflow job."
  value       = google_dataflow_job.this.state
}

# The type of the created Dataflow job.
output "job_type" {
  description = "The type of the created Dataflow job."
  value       = google_dataflow_job.this.type
}
