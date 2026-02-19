# OpenVPN Access Server GCP Deployment Tutorial

Welcome! This tutorial will guide you through downloading your deployment template for OpenVPN Access Server on Google Cloud Platform (GCP).

## Table of Contents

1. [Overview](#overview)
2. [Step 1: Open Google Cloud Shell](#step-1-open-google-cloud-shell)
3. [Step 2: Download Your Deployment Template](#step-2-download-your-deployment-template)
4. [Troubleshooting](#troubleshooting)

---

## Overview

This repository provides tools to download deployment templates for OpenVPN Access Server on GCP.

**What you'll do:**
- ✅ Open Google Cloud Shell (automatically done when you click the button in the portal)
- ✅ Download your deployment template from S3 using the provided URL

**Estimated time:** 2-3 minutes

---

## Step 1: Open Google Cloud Shell

**If you clicked the button in the AS Portal UI**, this step is already done! Google Cloud Shell has opened automatically and this repository has been cloned.

You should see:
- ✅ Google Cloud Shell terminal at the bottom of the screen
- ✅ This tutorial in the right panel
- ✅ File explorer showing the repository files on the left

**Verify you're in the correct directory:**

```bash
pwd
# Should show: /home/your-username/donotusethis
```

If you're not in the right directory, navigate to it:

```bash
cd ~/donotusethis
```

---

## Step 2: Download Your Deployment Template

Your deployment template is available via a secure S3 URL provided by the AS Portal.

### Get Your S3 Template URL

The S3 URL will be provided to you and looks like this (includes authentication tokens):

```
https://as-qa-deployment-scripts.s3.eu-central-1.amazonaws.com/data/483c9368-748f-4324-b514-7bb457aa668a?X-Amz-Security-Token=...&X-Amz-Algorithm=...&X-Amz-Signature=...
```

> **Note:** The URL is pre-signed and includes security tokens. It expires after 15 minutes for security reasons.

### Download the Template

Run the download script with your S3 URL:

```bash
./download-template.sh "YOUR_S3_URL_HERE" deployment.json
```

**Important:** Wrap the URL in quotes because it contains special characters.

**Example:**

```bash
./download-template.sh "https://as-qa-deployment-scripts.s3.eu-central-1.amazonaws.com/data/483c9368-748f-4324-b514-7bb457aa668a?X-Amz-Security-Token=IQoJb3JpZ2luX2VjELr...&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Signature=5eec5598..." deployment.json
```

### What Happens

The script will:
- ✅ Download the template from S3
- ✅ Validate it's proper JSON format
- ✅ Show you the file size
- ✅ Confirm successful download

**Expected Output:**

```
[INFO] Starting download from S3...
[INFO] Source URL: https://as-qa-deployment-scripts.s3.eu-central-1.amazonaws.com/...
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

**✅ That's it!** Your deployment template has been successfully downloaded and is ready to use.


---

## Troubleshooting

### Issue: "Template download failed"

**Possible causes:**
- ❌ S3 URL is incorrect or expired (URLs expire after 15 minutes)
- ❌ S3 URL not properly quoted (the URL contains special characters)
- ❌ No internet connectivity from Cloud Shell

**Solution:**

1. **Make sure to wrap the URL in quotes:**
   ```bash
   ./download-template.sh "YOUR_FULL_S3_URL_HERE" deployment.json
   ```

2. **Check if URL has expired:**
   The pre-signed S3 URLs are valid for 15 minutes. If download fails, request a new URL from the AS Portal.

3. **Test connectivity:**
   ```bash
   # Test basic connectivity
   curl -I https://www.google.com

   # Try downloading with verbose output
   curl -v -o deployment.json "YOUR_S3_URL_HERE"
   ```

4. **Check for error messages:**
   Common errors:
   - `403 Forbidden`: URL has expired, get a new one
   - `404 Not Found`: URL is incorrect
   - `Connection failed`: Check internet connectivity

### Issue: "Invalid JSON" error

**Cause:** The downloaded file is not valid JSON (possibly an error page).

**Solution:**
```bash
# Check what was downloaded
cat deployment.json

# If it shows HTML error page instead of JSON, the URL is invalid/expired
# Request a new S3 URL from the portal
```

---

**✅ Download Complete!**

Your deployment template is ready to use. The template contains all necessary configuration for deploying OpenVPN Access Server on GCP.

**Questions?** Contact your administrator or check the AS Portal documentation.
