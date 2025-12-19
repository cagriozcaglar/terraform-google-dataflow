output "job_id" {
  description = "The unique ID of the created Dataflow job."
  value       = local.create_job ? coalesce(try(google_dataflow_flex_template_job.flex_template_job[0].job_id, null), try(google_dataflow_job.classic_template_job[0].job_id, null)) : null
}

output "job_name" {
  description = "The name of the created Dataflow job."
  value       = local.create_job ? coalesce(try(google_dataflow_flex_template_job.flex_template_job[0].name, null), try(google_dataflow_job.classic_template_job[0].name, null)) : null
}

output "job_state" {
  description = "The current state of the Dataflow job."
  value       = local.create_job ? coalesce(try(google_dataflow_flex_template_job.flex_template_job[0].state, null), try(google_dataflow_job.classic_template_job[0].state, null)) : null
}
