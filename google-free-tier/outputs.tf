output "gcloud_ssh_command" {
  description = "gcloud command line used to SSH into the instance."
  value       = "gcloud beta compute ssh --zone \"${google_compute_instance.vm_centos.zone}\" \"${google_compute_instance.vm_centos.name}\" --tunnel-through-iap --project \"${var.project_id}\""
}