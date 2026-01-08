output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = google_dataflow_job.job.job_id
}

output "job_name" {
  description = "The name of the created Dataflow job."
  value       = google_dataflow_job.job.name
}

output "job_state" {
  description = "The current state of the Dataflow job."
  value       = google_dataflow_job.job.state
}
