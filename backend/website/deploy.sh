#!/bin/bash
# Deploy Ndmr Website (S3 + CloudFront)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEBSITE_DIR="$SCRIPT_DIR/../../website"

cd "$SCRIPT_DIR"

echo "=== Ndmr Website Deployment ==="

# Check for terraform.tfvars
if [ ! -f "terraform.tfvars" ]; then
    echo "Error: terraform.tfvars not found"
    exit 1
fi

# Initialize Terraform
echo ""
echo "1. Initializing Terraform..."
terraform init

# Plan
echo ""
echo "2. Planning deployment..."
terraform plan -out=tfplan

# Ask for confirmation
echo ""
read -p "Apply this plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# Apply
echo ""
echo "3. Applying changes..."
terraform apply tfplan

# Get outputs
BUCKET_NAME=$(terraform output -raw s3_bucket_name)
DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)

# Sync website content
echo ""
echo "4. Uploading website content to S3..."
aws s3 sync "$WEBSITE_DIR" "s3://$BUCKET_NAME" \
    --delete \
    --exclude ".DS_Store" \
    --exclude "*.map" \
    --profile feraudet

# Set correct content types
echo ""
echo "5. Setting content types..."
aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
    --exclude "*" \
    --include "*.html" \
    --content-type "text/html; charset=utf-8" \
    --metadata-directive REPLACE \
    --recursive \
    --profile feraudet

aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
    --exclude "*" \
    --include "*.css" \
    --content-type "text/css; charset=utf-8" \
    --metadata-directive REPLACE \
    --recursive \
    --profile feraudet

aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
    --exclude "*" \
    --include "*.js" \
    --content-type "application/javascript; charset=utf-8" \
    --metadata-directive REPLACE \
    --recursive \
    --profile feraudet

aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
    --exclude "*" \
    --include "*.json" \
    --content-type "application/json; charset=utf-8" \
    --metadata-directive REPLACE \
    --recursive \
    --profile feraudet

aws s3 cp "s3://$BUCKET_NAME" "s3://$BUCKET_NAME" \
    --exclude "*" \
    --include "*.svg" \
    --content-type "image/svg+xml" \
    --metadata-directive REPLACE \
    --recursive \
    --profile feraudet

# Invalidate CloudFront cache
echo ""
echo "6. Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
    --distribution-id "$DISTRIBUTION_ID" \
    --paths "/*" \
    --profile feraudet

# Show outputs
echo ""
echo "=== Deployment Complete ==="
terraform output

echo ""
echo "=== DNS Configuration Required ==="
echo "Add CNAME records pointing your domains to the CloudFront distribution:"
terraform output -raw dns_cname_record

echo ""
echo ""
echo "=== Certificate Validation ==="
echo "If the certificate is pending validation, add these DNS records:"
terraform output -json acm_validation_records | jq -r 'to_entries[] | "\(.key):\n  Name:  \(.value.name)\n  Type:  \(.value.type)\n  Value: \(.value.value)\n"'
