#!/bin/bash
set -e

# Deploy Ndmr Backend with OpenTofu

cd "$(dirname "$0")/infra"

# Check for terraform.tfvars
if [ ! -f terraform.tfvars ]; then
    echo "Error: terraform.tfvars not found"
    echo "Copy terraform.tfvars.example to terraform.tfvars and set your values"
    exit 1
fi

# Initialize (if needed)
if [ ! -d .terraform ]; then
    echo "Initializing OpenTofu..."
    tofu init
fi

# Plan
echo "Planning deployment..."
tofu plan -out=tfplan

# Apply
echo "Applying changes..."
tofu apply tfplan

# Show outputs
echo ""
echo "=== Deployment Complete ==="
tofu output
