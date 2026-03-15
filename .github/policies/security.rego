package terraform.security

# CRITICAL: Blockera om VM saknar säkerhetshärdning
deny[msg] {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "google_compute_instance"
  not resource.values.metadata_startup_script
  msg := "CRITICAL: VM saknar startup-script (CIS 5.x)"
}

# CRITICAL: Blockera IP-forwarding
deny[msg] {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "google_compute_instance"
  resource.values.can_ip_forward == true
  msg := "CRITICAL: IP-forwarding aktiverat (CIS 4.1.1)"
}

# CRITICAL: Blockera root login
deny[msg] {
  plan_contains_ssh_config("PermitRootLogin.*yes")
  msg := "CRITICAL: Root login tillåtet i SSH config"
}

# Hjälpfunktion
plan_contains_ssh_config(pattern) {
  resource := input.planned_values.root_module.resources[_]
  contains(lower(resource.values.metadata_startup_script), pattern)
}
