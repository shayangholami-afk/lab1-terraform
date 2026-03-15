output "vm_ip" {
  description = "VM External IP"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "snapshot_policy" {
  description = "CIS VM härdning status"
  value       = "90% CIS Benchmark compliance"
}

