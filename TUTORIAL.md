# OpenVPN Access Server GCP Deployment

**Estimated time:** 2-3 minutes

Authenticate with Google Cloud (will open browser window):

```bash
gcloud auth application-default login
```

Copy the generated credentials file path (looks like `/tmp/tmp.XXXXXXXXXX/application_default_credentials.json`) and set it:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/tmp/tmp.XXXXXXXXXX/application_default_credentials.json"
```

Download and execute the deployment script from the S3 URL provided by the AS Portal (**Note:** URL expires in 15 minutes):

```bash
curl -fsSL \
    "YOUR_S3_URL_HERE" -o \
    deploy.sh && chmod +x deploy.sh && bash deploy.sh
```

The script will create `gcp.tfvars`, run `terraform init` and `terraform apply`. **Type `yes` when prompted to confirm deployment.**

---

**✅ Complete!** Your OpenVPN Access Server is being deployed.


## Troubleshooting

**Authentication issues:** Verify credentials with `echo $GOOGLE_APPLICATION_CREDENTIALS` or re-run `gcloud auth application-default login`

**Download failed:** URL expired (15 min validity) → Request new URL from portal, or check connectivity with `curl -I https://www.google.com`

**Deployment failed:** Verify credentials are set, check `gcp.tfvars` was created, then re-run `bash deploy.sh`

---

**Questions?** Contact your administrator or check the AS Portal documentation.
