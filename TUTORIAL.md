# OpenVPN Access Server GCP Deployment

Welcome! This tutorial will guide you through downloading your deployment template for OpenVPN Access Server on Google Cloud Platform (GCP).

**Estimated time:** 2-3 minutes

## Verify Cloud Shell Environment

Google Cloud Shell has opened automatically and the repository has been cloned.

Verify you're in the correct directory:

```bash
cd ~/donotusethis && pwd
```

Expected output: `/home/your-username/donotusethis`

## Download Deployment Template

Your deployment template is available via a secure S3 URL provided by the AS Portal.

The S3 URL looks like this (includes authentication tokens):

```
https://as-qa-deployment-scripts.s3.eu-central-1.amazonaws.com/data/483c9368-...?X-Amz-Security-Token=...&X-Amz-Signature=...
```

**Note:** The URL is pre-signed and expires after 15 minutes for security reasons.

Run the download script with your S3 URL (wrap in quotes):

```bash
./download-template.sh "YOUR_S3_URL_HERE" deployment.json
```

Expected output:

```
[SUCCESS] Template downloaded successfully to: deployment.json
[SUCCESS] Template is valid JSON
```

Verify the download:

```bash
cat deployment.json
```

## Download Deployment Script

Download the deployment script from the repository:

```bash
curl -fsSL https://raw.githubusercontent.com/DmitriyVasilyevPRV/donotusethis/main/deploy.sh -o deploy.sh && chmod +x deploy.sh
```

Verify the script is executable:

```bash
ls -lh deploy.sh
```

---

**✅ Complete!** Your deployment template and script are ready to use.


## Troubleshooting

**Template download failed?**

Common issues:
- URL expired (valid for 15 minutes) → Request new URL from portal
- Missing quotes → Wrap URL in quotes: `"YOUR_URL"`
- Invalid JSON → URL is incorrect/expired, get new URL

Test connectivity:
```bash
curl -I https://www.google.com
```

**Script download failed?**

```bash
# Verify internet access
curl -I https://raw.githubusercontent.com

# Try download again
curl -fsSL https://raw.githubusercontent.com/DmitriyVasilyevPRV/donotusethis/main/deploy.sh -o deploy.sh
```

---

**Questions?** Contact your administrator or check the AS Portal documentation.
