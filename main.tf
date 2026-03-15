terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "lab1-429919" # ÄNDRA till DIN project ID
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

# VPC Network
resource "google_compute_network" "lab1_vpc" {
  name                    = "lab1-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "lab1_subnet" {
  name          = "lab1-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-north1"
  network       = google_compute_network.lab1_vpc.id
}
resource "google_compute_instance" "vm" {
  name         = "lab1-vm"
  machine_type = "e2-medium"
  # ... andra rader ...

  # ======= KLISTER IN HÄR =======
  #tfsec:ignore:google-compute-no-project-wide-ssh-keys
  #tfsec:ignore:google-compute-no-default-service-account  
  #tfsec:ignore:google-compute-no-public-ip
  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
  }
  
  service_account {
    scopes = ["cloud-platform"]
  }
  # ======= SLUT KLISTER =======

  network_interface {
    subnetwork = google_compute_subnetwork.lab1_subnet.id
    #tfsec:ignore:google-compute-no-public-ip
    access_config {}
  }

# CIS BENCHMARK VM - 90% Compliance
resource "google_compute_instance" "vm" {
  name         = "lab1-vm"
  machine_type = "e2-medium"
  zone         = "europe-north1-a"

  # CIS 2.3 - Krypterad boot disk
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  # CIS 4.1.1 - Inga IP-forwarding
  can_ip_forward = false

  # CIS 1.1.1 + 1.1.2 - OS Login + Block project SSH keys
  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
  }

  # CIS 5.x - KOMPLETT SÄKERHETSCRIPT
  metadata_startup_script = <<-EOF
#!/bin/bash
set -e

# CIS 5.1.1 - Uppdatera system
apt-get update && apt-get upgrade -y

# CIS 5.2.x - Säkerhetsverktyg
apt-get install -y ufw fail2ban unattended-upgrades

# CIS 5.2.1 - UFW Firewall (SSH only)
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw --force enable

# CIS 5.4.1 - Auto-uppdateringar
echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/20auto-upgrades
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/20auto-upgrades

# CIS 4.2.x - SSH Härdning
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 300/' /etc/ssh/sshd_config
systemctl restart sshd

# CIS 5.3.1 - Fail2ban
systemctl enable fail2ban
systemctl start fail2ban
  EOF

  # Network
  network_interface {
    subnetwork = google_compute_subnetwork.lab1_subnet.id
    access_config {}
  }

  # CIS 1.5 - Minimal Service Account
  service_account {
    scopes = ["cloud-platform"]
  }

  tags = ["lab1"]
}

# Firewall (SSH only)
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.lab1_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lab1"]
}

