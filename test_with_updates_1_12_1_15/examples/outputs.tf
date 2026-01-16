output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = module.dataflow_flex_job.job_id
}

output "job_name" {
  description = "The name of the created Dataflow job."
  value       = module.dataflow_flex_job.name
}

output "job_state" {
  description = "The current state of the created Dataflow job."
  value       = module.dataflow_flex_job.state
}

output "job_type" {
  description = "The type of the created Dataflow job."
  value       = module.dataflow_flex_job.type
}

output "dataflow_service_account_email" {
  description = "The email of the service account created for the Dataflow job."
  value       = google_service_account.dataflow_sa.email
}

output "gcs_bucket_name" {
  description = "The name of the GCS bucket created for staging and templates."
  value       = google_storage_bucket.bucket.name
}
