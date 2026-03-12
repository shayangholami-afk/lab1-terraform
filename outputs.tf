output "vm_name" {
  value = google_compute_instance.vm_instance.name
}

output "vm_external_ip" {
  value = "Ej konfigurerad (ingen extern IP konfigurerad)"
}


output "vm_zone" {
  value = google_compute_instance.vm_instance.zone
}

