# OpenVPN Access Server GCP Deployment

Welcome! This tutorial will guide you through deploying OpenVPN Access Server on Google Cloud Platform.

**Estimated time:** 2-3 minutes

## Download Deployment Script

Download the deployment script from the secure S3 URL provided by the AS Portal.

The S3 URL looks like this (includes authentication tokens):

```
https://as-qa-deployment-scripts.s3.eu-central-1.amazonaws.com/data/483c9368-...?X-Amz-Security-Token=...&X-Amz-Signature=...
```

**Note:** The URL is pre-signed and expires after 15 minutes for security.

Download the script using curl (wrap URL in quotes):

```bash
curl -fsSL "YOUR_S3_URL_HERE" -o deploy.sh && chmod +x deploy.sh
```

Verify the script was downloaded:

```bash
ls -lh deploy.sh
```

Expected output: `-rwxr-xr-x ... deploy.sh`

## Execute Deployment Script

Run the deployment script:

```bash
./deploy.sh
```

The script will deploy OpenVPN Access Server on GCP.

Follow any prompts or instructions displayed by the script.

---

**✅ Complete!** Your OpenVPN Access Server deployment is in progress.


## Troubleshooting

**Script download failed?**

Common issues:
- URL expired (valid for 15 minutes) → Request new URL from portal
- Missing quotes → Wrap URL in quotes: `"YOUR_URL"`
- No internet connectivity → Test with: `curl -I https://www.google.com`

Try download again with verbose output:

```bash
curl -v -fsSL "YOUR_S3_URL_HERE" -o deploy.sh
```

**Script execution failed?**

```bash
# Check if script is executable
ls -lh deploy.sh

# Make it executable if needed
chmod +x deploy.sh

# Run with bash explicitly
bash deploy.sh
```

---

**Questions?** Contact your administrator or check the AS Portal documentation.
