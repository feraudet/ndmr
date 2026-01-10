#!/bin/bash
# Deploy Ndmr Feedback API (Lambda + API Gateway)

set -e

cd "$(dirname "$0")"

echo "=== Ndmr Feedback API Deployment ==="

# Check for terraform.tfvars
if [ ! -f "terraform.tfvars" ]; then
    echo "Error: terraform.tfvars not found"
    echo "Copy terraform.tfvars.example to terraform.tfvars and configure it"
    exit 1
fi

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Plan
echo "Planning deployment..."
terraform plan -out=tfplan

# Apply
echo "Applying changes..."
terraform apply tfplan

# Show outputs
echo ""
echo "=== Deployment Complete ==="
terraform output

echo ""
echo "Test with:"
echo 'curl -X POST $(terraform output -raw feedback_url) -H "Content-Type: application/json" -d '\''{"type":"feedback","name":"Test","message":"Hello from CLI"}'\'''
