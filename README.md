# Lab 1 – Terraform + GCP VM (DevSecOps 2026)

## Vad projektet gör
Det här projektet skapar en Ubuntu 22.04-VM i Google Cloud Platform i regionen europe-north1 med Terraform.

## Hur man kör

**Förutsättningar:**  
- Installerad Terraform CLI  
- Google Cloud-projekt `chas-devsecops-2026`  
- Service account‑nyckel, t.ex. `~/gcp-keys/terraform-lab1.json`, satt som `GOOGLE_APPLICATION_CREDENTIALS`  
- Git installerat

## Säkerhetsbeslut
- **ufw**: Blockera all trafik utom SSH  
- **fail2ban**: Skydd mot brute force attacker
- **Dagliga snapshots**: Backup kl 03:00 (7 dagar retention)

 # Initiera Terraform (hämtar provider och backend)
terraform init

# Granska vilka resurser som kommer skapas
terraform plan

# Skapa VM, snapshot-policy och kopplingen mellan dem
terraform apply
