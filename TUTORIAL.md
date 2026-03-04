# OpenVPN Access Server GCP Deployment

Welcome! This tutorial will guide you through deploying OpenVPN Access Server on Google Cloud Platform.

**Estimated time:** 2-3 minutes

## Step 1: Authenticate with GCP

Run the following command to authenticate with Google Cloud (this will open a browser window):

```bash
gcloud auth application-default login
```

This process will generate an authentication file at a path like:
```
/tmp/tmp.SGYP0a7i9t/application_default_credentials.json
```

**Copy the file path** from the output, then set it as an environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/tmp/tmp.XXXXXXXXXX/application_default_credentials.json"
```

Replace the path with the actual path from the previous command.

## Step 2: Download and Execute Deployment Script

Download the deployment script from the secure S3 URL provided by the AS Portal.

**Note:** The S3 URL is pre-signed and expires after 15 minutes for security.

Run the following command (replace `YOUR_S3_URL_HERE` with your actual S3 URL):

```bash
curl -fsSL \
    "YOUR_S3_URL_HERE" -o \
    deploy.sh && chmod +x deploy.sh && bash deploy.sh
```

The script will:
1. Create `gcp.tfvars` configuration file
2. Run `terraform init` to initialize Terraform
3. Run `terraform apply` to deploy infrastructure

**Important:** When prompted, type `yes` to confirm the Terraform deployment.

---

**✅ Complete!** Your OpenVPN Access Server deployment is in progress.


## Troubleshooting

**Authentication failed?**

```bash
# Verify credentials are set
echo $GOOGLE_APPLICATION_CREDENTIALS

# Re-authenticate if needed
gcloud auth application-default login
```

**Script download failed?**

Common issues:
- URL expired (valid for 15 minutes) → Request new URL from portal
- Missing quotes → Wrap URL in quotes: `"YOUR_URL"`
- No internet connectivity → Test with: `curl -I https://www.google.com`

Try download again with verbose output:

```bash
curl -v -fsSL \
    "YOUR_S3_URL_HERE" -o deploy.sh
```

**Terraform apply failed?**

```bash
# Verify credentials are set
echo $GOOGLE_APPLICATION_CREDENTIALS

# Check Terraform state
cat gcp.tfvars

# Re-run deployment
bash deploy.sh
```

---

**Questions?** Contact your administrator or check the AS Portal documentation.
