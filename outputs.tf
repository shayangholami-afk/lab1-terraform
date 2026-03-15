output "vm_name" {
  description = "Namn på den skapade VM"
  value       = google_compute_instance.vm.name
}

output "vm_internal_ip" {
  description = "Intern IP-adress för VM (ingen extern IP pga quota)"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "snapshot_policy" {
  description = "Daglig backup-policy"
  value       = google_compute_resource_policy.daily_backup.name
}
