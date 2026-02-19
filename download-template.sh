#!/bin/bash

# Download template script for OpenVPN Access Server GCP deployment
# This script downloads deployment templates from S3 and sets up the environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if S3 URL is provided
if [ -z "$1" ]; then
    print_error "No S3 URL provided"
    echo "Usage: $0 <s3-url> [output-filename]"
    echo "Example: $0 https://my-bucket.s3.amazonaws.com/path/to/file.json template.json"
    exit 1
fi

S3_URL="$1"
OUTPUT_FILE="${2:-downloaded-template.json}"

print_info "Starting download from S3..."
print_info "Source URL: ${S3_URL}"
print_info "Output file: ${OUTPUT_FILE}"

# Check if curl or wget is available
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -fsSL -o"
    print_info "Using curl for download"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -q -O"
    print_info "Using wget for download"
else
    print_error "Neither curl nor wget is available. Please install one of them."
    exit 1
fi

# Download the file
print_info "Downloading template..."
if $DOWNLOAD_CMD "${OUTPUT_FILE}" "${S3_URL}"; then
    print_success "Template downloaded successfully to: ${OUTPUT_FILE}"

    # Check if the file is valid JSON
    if command -v jq &> /dev/null; then
        print_info "Validating JSON format..."
        if jq empty "${OUTPUT_FILE}" 2>/dev/null; then
            print_success "Template is valid JSON"
        else
            print_warning "Downloaded file may not be valid JSON"
        fi
    fi

    # Show file info
    FILE_SIZE=$(stat -f%z "${OUTPUT_FILE}" 2>/dev/null || stat -c%s "${OUTPUT_FILE}" 2>/dev/null || echo "unknown")
    print_info "File size: ${FILE_SIZE} bytes"

    echo ""
    print_success "Download complete!"
    echo ""
    print_info "Next steps:"
    echo "  1. Review the template: cat ${OUTPUT_FILE}"
    echo "  2. Use it in your Terraform deployment"

    exit 0
else
    print_error "Failed to download template from ${S3_URL}"
    print_error "Please check:"
    echo "  - The S3 URL is correct and accessible"
    echo "  - You have internet connectivity"
    echo "  - The S3 bucket has public read access or you have credentials configured"
    exit 1
fi
