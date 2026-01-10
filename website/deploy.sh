#!/bin/bash
# ===========================================
# Ndmr Website - Deploy Script
# ===========================================

set -e

# Configuration
BUCKET_NAME="${BUCKET_NAME:-ndmr.app}"
DISTRIBUTION_ID="${DISTRIBUTION_ID:-}"
REGION="${AWS_REGION:-eu-west-3}"
WEBSITE_DIR="$(dirname "$0")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Ndmr Website - Deployment${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}Error: AWS credentials not configured${NC}"
    exit 1
fi

echo -e "${GREEN}AWS CLI configured${NC}"

# Sync website to S3
echo ""
echo -e "${YELLOW}Syncing website to S3...${NC}"
aws s3 sync "$WEBSITE_DIR" "s3://$BUCKET_NAME" \
    --exclude "*.sh" \
    --exclude "infra/*" \
    --exclude ".DS_Store" \
    --exclude "*.md" \
    --delete \
    --cache-control "max-age=3600" \
    --region "$REGION"

# Set specific cache headers for assets
echo -e "${YELLOW}Setting cache headers for static assets...${NC}"

# CSS files (1 week cache)
aws s3 cp "s3://$BUCKET_NAME/css/" "s3://$BUCKET_NAME/css/" \
    --recursive \
    --cache-control "max-age=604800" \
    --content-type "text/css" \
    --metadata-directive REPLACE \
    --region "$REGION" 2>/dev/null || true

# JS files (1 week cache)
aws s3 cp "s3://$BUCKET_NAME/js/" "s3://$BUCKET_NAME/js/" \
    --recursive \
    --cache-control "max-age=604800" \
    --content-type "application/javascript" \
    --metadata-directive REPLACE \
    --region "$REGION" 2>/dev/null || true

# Image files (1 week cache)
aws s3 cp "s3://$BUCKET_NAME/img/" "s3://$BUCKET_NAME/img/" \
    --recursive \
    --cache-control "max-age=604800" \
    --metadata-directive REPLACE \
    --region "$REGION" 2>/dev/null || true

echo -e "${GREEN}Files synced successfully${NC}"

# Invalidate CloudFront cache
if [ -n "$DISTRIBUTION_ID" ]; then
    echo ""
    echo -e "${YELLOW}Invalidating CloudFront cache...${NC}"
    INVALIDATION_ID=$(aws cloudfront create-invalidation \
        --distribution-id "$DISTRIBUTION_ID" \
        --paths "/*" \
        --query 'Invalidation.Id' \
        --output text)
    echo -e "${GREEN}Cache invalidation started: $INVALIDATION_ID${NC}"
else
    echo ""
    echo -e "${YELLOW}Note: Set DISTRIBUTION_ID to invalidate CloudFront cache${NC}"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Deployment complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Website URL: ${BLUE}https://$BUCKET_NAME${NC}"
