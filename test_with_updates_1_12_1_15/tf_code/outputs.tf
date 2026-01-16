output "job_id" {
  description = "The unique ID of the Dataflow job."
  value       = google_dataflow_job.dataflow_flex_template_job.job_id
}

output "name" {
  description = "The name of the Dataflow job."
  value       = google_dataflow_job.dataflow_flex_template_job.name
}

output "state" {
  description = "The current state of the Dataflow job."
  value       = google_dataflow_job.dataflow_flex_template_job.state
}

output "type" {
  description = "The type of the Dataflow job (e.g., JOB_TYPE_STREAMING, JOB_TYPE_BATCH)."
  value       = google_dataflow_job.dataflow_flex_template_job.type
}
