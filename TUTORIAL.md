# OpenVPN Access Server GCP Deployment Tutorial

Welcome! This tutorial will guide you through deploying OpenVPN Access Server on Google Cloud Platform (GCP) using Terraform and our automated deployment tools.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Step 1: Open Google Cloud Shell](#step-1-open-google-cloud-shell)
4. [Step 2: Download Your Deployment Template](#step-2-download-your-deployment-template)
5. [Step 3: Configure Your Deployment](#step-3-configure-your-deployment)
6. [Step 4: Deploy with Terraform](#step-4-deploy-with-terraform)
7. [Step 5: Access Your OpenVPN Server](#step-5-access-your-openvpn-server)
8. [Troubleshooting](#troubleshooting)
9. [Cleanup](#cleanup)

---

## Overview

This repository provides Terraform templates to deploy OpenVPN Access Server on GCP. The deployment process:

- ✅ Creates a GCP Compute Engine instance with OpenVPN Access Server pre-installed
- ✅ Configures firewall rules for VPN access (ports 443, 943, 1194)
- ✅ Sets up networking (VPC, subnet, external IP)
- ✅ Generates a secure admin password automatically
- ✅ Provides you with the admin portal URL and credentials

**Estimated deployment time:** 5-10 minutes

---

## Prerequisites

Before you begin, ensure you have:

- ✅ **A Google Cloud Platform account** - [Sign up here](https://cloud.google.com/)
- ✅ **A GCP project** with billing enabled
- ✅ **An S3 template URL** provided by your administrator or portal
- ✅ **OpenVPN Access Server subscription** (activation key will be in the template)

> **Note:** All commands in this tutorial are run in Google Cloud Shell, which is free and pre-configured with all necessary tools (Terraform, gcloud CLI, etc.). No local installation required!

---

## Step 1: Open Google Cloud Shell

### Option A: Using the Portal UI

1. Navigate to the AS Portal UI
2. Go to **Templates → Deployments → Cloud Shell Deployment**
3. Click **"🚀 Open Google Cloud Shell"**
4. A new tab will open with Google Cloud Shell
5. The repository will be automatically cloned for you

### Option B: Manual Setup

If you prefer to set up manually:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the **Cloud Shell icon** (top right, looks like `>_`)
3. Once Cloud Shell opens, clone this repository:

```bash
git clone https://github.com/DmitriyVasilyevPRV/donotusethis.git
cd donotusethis
```

### Verify Your Environment

Check that you're in the correct directory:

```bash
pwd
# Should show: /home/your-username/donotusethis

ls -la
# Should show files including: download-template.sh, main.tf, variables.tf
```

---

## Step 2: Download Your Deployment Template

Your deployment template contains all the configuration needed for your OpenVPN server, including your activation key.

### Get Your S3 Template URL

You should have received an S3 URL from the AS Portal. It looks like:

```
https://bucket-name.s3.amazonaws.com/path/to/your-template.json
```

### Download the Template

Run the download script with your S3 URL:

```bash
./download-template.sh https://your-s3-url-here.s3.amazonaws.com/template.json deployment.json
```

**Example:**

```bash
./download-template.sh https://openvpn-templates.s3.us-east-1.amazonaws.com/templates/abc123/deployment.json deployment.json
```

### What Happens

The script will:
- ✅ Download the template from S3
- ✅ Validate it's proper JSON format
- ✅ Show you the file size
- ✅ Display next steps

**Expected Output:**

```
[INFO] Starting download from S3...
[INFO] Source URL: https://...
[INFO] Output file: deployment.json
[INFO] Using curl for download
[INFO] Downloading template...
[SUCCESS] Template downloaded successfully to: deployment.json
[INFO] Validating JSON format...
[SUCCESS] Template is valid JSON
[INFO] File size: 1234 bytes

[SUCCESS] Download complete!
```

### Verify Download

Check the downloaded file:

```bash
cat deployment.json
```

You should see JSON content with your deployment configuration.

---

## Step 3: Configure Your Deployment

### Set Your GCP Project

First, set your GCP project ID:

```bash
# List available projects
gcloud projects list

# Set your project
export GOOGLE_PROJECT_ID="your-project-id-here"
gcloud config set project $GOOGLE_PROJECT_ID
```

### Create Terraform Variables File

Create a `terraform.tfvars` file with your configuration:

```bash
cat > terraform.tfvars <<EOF
# GCP Project Configuration
project_id = "$GOOGLE_PROJECT_ID"

# Deployment Name (used for resource naming)
goog_cm_deployment_name = "openvpn-as"

# Region and Zone
zone = "us-central1-a"

# VM Configuration
machine_type = "e2-medium"
boot_disk_size = 30
boot_disk_type = "pd-standard"

# Network Configuration
enable_tcp_443 = true
enable_tcp_943 = true
enable_udp_1194 = true
enable_tcp_22 = true

# Firewall Source Ranges (0.0.0.0/0 = allow from anywhere)
tcp_443_source_ranges = "0.0.0.0/0"
tcp_943_source_ranges = "0.0.0.0/0"
udp_1194_source_ranges = "0.0.0.0/0"
tcp_22_source_ranges = "0.0.0.0/0"
EOF
```

### Customize Your Configuration (Optional)

You can customize the following variables:

| Variable | Description | Default | Recommended |
|----------|-------------|---------|-------------|
| `machine_type` | VM size | `e2-medium` | `e2-medium` for small deployments, `e2-standard-2` for production |
| `zone` | GCP zone | - | Choose closest to your users |
| `boot_disk_size` | Disk size in GB | `30` | `30` GB is sufficient |
| `tcp_22_source_ranges` | SSH access | `0.0.0.0/0` | **Restrict to your IP for security!** |

**Security Tip:** Restrict SSH access to your IP address:

```bash
# Get your current IP
MY_IP=$(curl -s ifconfig.me)

# Update terraform.tfvars
sed -i "s/tcp_22_source_ranges = \"0.0.0.0\/0\"/tcp_22_source_ranges = \"$MY_IP\/32\"/" terraform.tfvars
```

---

## Step 4: Deploy with Terraform

### Initialize Terraform

Initialize Terraform to download required providers:

```bash
terraform init
```

**Expected Output:**

```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Installing hashicorp/google...

Terraform has been successfully initialized!
```

### Preview the Deployment

See what resources will be created:

```bash
terraform plan
```

Review the output. You should see:
- 1 Compute Instance (VM)
- 4 Firewall Rules (for ports 22, 443, 943, 1194)
- 1 VPC Network and Subnet (if creating new)
- 1 Random Password resource

### Deploy the Infrastructure

Apply the Terraform configuration:

```bash
terraform apply
```

Type `yes` when prompted to confirm.

**Deployment Progress:**

```
google_compute_network.vpc: Creating...
google_compute_firewall.tcp_443: Creating...
random_password.admin: Creating...
google_compute_instance.instance: Creating...

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

admin_password = <sensitive>
admin_url = "https://34.123.45.67:943/admin"
external_ip = "34.123.45.67"
```

⏱️ **Deployment takes approximately 3-5 minutes.**

### View Deployment Outputs

Once complete, view your deployment information:

```bash
terraform output
```

To see the admin password (it's marked as sensitive):

```bash
terraform output admin_password
```

**Save these values!** You'll need them to access your OpenVPN server.

---

## Step 5: Access Your OpenVPN Server

### Initial Setup (First 5 Minutes)

After Terraform completes, the VM needs additional time to:
- Install OpenVPN Access Server
- Configure the license
- Start services

⏱️ **Wait 5 minutes** before accessing the admin portal.

### Access the Admin Portal

1. Get your admin URL from the Terraform output:

```bash
terraform output admin_url
```

2. Open the URL in your browser (example: `https://34.123.45.67:943/admin`)

3. You'll see a security warning (self-signed certificate) - this is normal:
   - **Chrome/Edge:** Click "Advanced" → "Proceed to..."
   - **Firefox:** Click "Advanced" → "Accept the Risk and Continue"

4. Login with credentials:
   - **Username:** `openvpn`
   - **Password:** Get from `terraform output admin_password`

### Client Download Portal

Your users can download VPN clients from:

```
https://<your-ip>:943/
```

Example: `https://34.123.45.67:943/`

### First Login Checklist

After logging in, you should:

1. ✅ **Review Network Settings** - Verify the hostname is correct
2. ✅ **Configure Authentication** - Set up user accounts or integrate with LDAP/SAML
3. ✅ **Review VPN Settings** - Configure routing and DNS as needed
4. ✅ **Test Connection** - Download the client and test VPN connectivity
5. ✅ **Configure SSL Certificate** - Replace self-signed cert with proper SSL cert (optional)

---

## Troubleshooting

### Issue: "Template download failed"

**Possible causes:**
- ❌ S3 URL is incorrect or expired
- ❌ No internet connectivity from Cloud Shell

**Solution:**
```bash
# Test connectivity
curl -I https://www.google.com

# Verify S3 URL is accessible
curl -I <your-s3-url>

# Try downloading again with verbose output
curl -v -o deployment.json <your-s3-url>
```

### Issue: "Admin portal returns 502 Bad Gateway"

**Cause:** OpenVPN services are still initializing.

**Solution:**
```bash
# SSH into the instance
gcloud compute ssh openvpn-as-vm --zone=us-central1-a

# Check service status
sudo /usr/local/openvpn_as/scripts/sacli status

# Wait for "subscription": "on" to appear
# Then check the web service
sudo systemctl status openvpnas

# Exit SSH
exit
```

Wait 2-3 more minutes and try again.

### Issue: "Can't connect to VPN"

**Check firewall rules:**

```bash
# Verify firewall rules are created
gcloud compute firewall-rules list | grep openvpn

# Should show rules for ports 443, 943, 1194, 22
```

**Check client configuration:**
- Ensure you downloaded the latest client profile
- Verify the server hostname/IP is correct
- Check your local firewall isn't blocking VPN connections

### Issue: "Terraform apply fails with permission error"

**Solution:**

```bash
# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Verify you have necessary permissions
gcloud projects get-iam-policy $GOOGLE_PROJECT_ID
```

You need at least `Compute Admin` and `Service Account User` roles.

### View VM Logs

To check startup script execution:

```bash
# SSH into VM
gcloud compute ssh openvpn-as-vm --zone=us-central1-a

# View startup script logs
sudo journalctl -u google-startup-scripts.service

# View OpenVPN installation log
sudo cat /var/log/syslog | grep openvpn

# Exit
exit
```

---

## Cleanup

To delete all created resources and avoid ongoing charges:

### Destroy Infrastructure

```bash
terraform destroy
```

Type `yes` when prompted.

This will remove:
- ✅ The VM instance
- ✅ All firewall rules
- ✅ The VPC network and subnet
- ✅ The external IP address

### Verify Cleanup

```bash
# Check no instances remain
gcloud compute instances list

# Check no firewall rules remain
gcloud compute firewall-rules list | grep openvpn
```

---

## Advanced Configuration

### Using Custom VPC

If you want to use an existing VPC instead of creating a new one:

```bash
# Add to terraform.tfvars
create_vpc = false
existing_network = "my-existing-vpc"
existing_subnet = "my-existing-subnet"
```

### Customizing Install Script

The startup script in `main.tf` installs OpenVPN AS 3.0.2. To use a different version:

```hcl
# Edit main.tf, line 45
bash -c 'bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --yes --as-version=3.0.3'
```

### Adding Custom Metadata

Add custom environment variables to the VM:

```bash
# Edit terraform.tfvars
env_vars = {
  admin_pw = ""  # Auto-generated if empty
  custom_var = "custom_value"
}
```

---

## Additional Resources

### Documentation Links

- 📚 [OpenVPN Access Server Admin Guide](https://openvpn.net/vpn-server-resources/access-server-admin-guide/)
- 📚 [GCP Terraform Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- 📚 [OpenVPN Access Server Installation](https://openvpn.net/access-server/docs/)

### Support

- 🆘 OpenVPN Support: [https://openvpn.net/support/](https://openvpn.net/support/)
- 🆘 GCP Support: [https://cloud.google.com/support](https://cloud.google.com/support)

### Common Next Steps

After deployment:

1. **Set up user authentication** - Configure local users or integrate with your directory service
2. **Configure routing** - Decide which traffic goes through VPN (split-tunnel vs full-tunnel)
3. **Set up monitoring** - Use GCP Cloud Monitoring to track instance health
4. **Implement backups** - Create snapshot schedules for your VM disk
5. **SSL certificate** - Replace self-signed cert with Let's Encrypt or your company cert
6. **High availability** - Deploy multiple instances in different zones for redundancy

---

## Quick Reference Commands

```bash
# Download template
./download-template.sh <s3-url> deployment.json

# Set GCP project
gcloud config set project <project-id>

# Initialize and deploy
terraform init
terraform plan
terraform apply

# Get outputs
terraform output
terraform output admin_password

# SSH to instance
gcloud compute ssh openvpn-as-vm --zone=<your-zone>

# Destroy everything
terraform destroy
```

---

## FAQ

**Q: How much does this cost?**

A: Costs depend on VM size and uptime. For an `e2-medium` instance running 24/7:
- Compute: ~$24/month
- Networking: ~$1-5/month (depends on data transfer)
- Storage: ~$2/month for 30GB disk

Use [GCP Pricing Calculator](https://cloud.google.com/products/calculator) for estimates.

**Q: Can I use this for production?**

A: Yes, but consider:
- Using a larger instance type (`e2-standard-2` or higher)
- Setting up Cloud Monitoring and alerting
- Implementing automated backups
- Deploying across multiple zones for HA
- Restricting SSH access by IP

**Q: How do I upgrade OpenVPN Access Server?**

A: SSH into the instance and run:

```bash
sudo apt-get update
sudo apt-get install openvpn-as
```

**Q: Can I change the admin password?**

A: Yes, SSH into the instance:

```bash
sudo /usr/local/openvpn_as/scripts/sacli --user openvpn --new_pass <new-password> SetLocalPassword
```

**Q: How many users can this support?**

A: Depends on VM size:
- `e2-medium`: 10-25 concurrent users
- `e2-standard-2`: 25-50 concurrent users
- `e2-standard-4`: 50-100 concurrent users

---

**Happy VPN-ing! 🚀**

Need help? Check the [Troubleshooting](#troubleshooting) section or contact support.
