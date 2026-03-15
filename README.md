Lab 1 - Terraform DevSecOps

**Projektbeskrivning**
Detta projekt skapar en Ubuntu VM i Google Cloud med Terraform. Den inkluderar en backup-policy och en basic säkerhetshärdning via startup-script.

**Hur man kör**
\`\`\`bash
terraform init
terraform plan  
terraform apply
\`\`\`

**Min Labb**

### Google Compute Engine
Här är en screenshot från Google Compute Engine:  
![GCE Screenshot](screenshots/vm-details.png)

### Terraform Pipeline
Så här såg Terraform pipeline ut:  
![Pipeline Screenshot](screenshots/pipeline.png)

**Säkerhetsbeslut**
- ufw – blockerar alla inkommande förutom SSH
- fail2ban – skyddar mot brute-force attackers  
- unattended-upgrades – håller systemet uppdaterat automatiskt
