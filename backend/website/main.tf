# Ndmr Website - Static hosting with S3 + CloudFront
# Domains: ndmr.fr, ndmr.app, ndmr.eu

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Main provider (eu-west-3 Paris)
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# US-East-1 provider for ACM certificates (required for CloudFront)
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}

# -----------------------------------------------------------------------------
# S3 Bucket for static website
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name        = "Ndmr Website"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -----------------------------------------------------------------------------
# CloudFront Origin Access Control
# -----------------------------------------------------------------------------

resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "ndmr-website-oac"
  description                       = "OAC for Ndmr website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 bucket policy for CloudFront
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# Route53 Hosted Zones
# -----------------------------------------------------------------------------

data "aws_route53_zone" "ndmr_app" {
  name = "ndmr.app."
}

data "aws_route53_zone" "ndmr_fr" {
  name = "ndmr.fr."
}

data "aws_route53_zone" "ndmr_eu" {
  name = "ndmr.eu."
}

locals {
  # Build domain to zone mapping dynamically based on configured domains
  all_domains = concat([var.primary_domain], var.alternate_domains)

  domain_zone_map = {
    for domain in local.all_domains : domain => (
      can(regex("ndmr\\.app", domain)) ? data.aws_route53_zone.ndmr_app.zone_id :
      can(regex("ndmr\\.fr", domain)) ? data.aws_route53_zone.ndmr_fr.zone_id :
      can(regex("ndmr\\.eu", domain)) ? data.aws_route53_zone.ndmr_eu.zone_id :
      null
    )
  }

  # Apex domains (without www)
  apex_domains = [for d in local.all_domains : d if !startswith(d, "www.")]

  # WWW domains
  www_domains = [for d in local.all_domains : d if startswith(d, "www.")]
}

# -----------------------------------------------------------------------------
# ACM Certificate (must be in us-east-1 for CloudFront)
# -----------------------------------------------------------------------------

resource "aws_acm_certificate" "website" {
  provider = aws.us_east_1

  domain_name               = var.primary_domain
  subject_alternative_names = var.alternate_domains
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "Ndmr Website Certificate"
    Environment = var.environment
  }
}

# DNS validation records
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = local.domain_zone_map[dvo.domain_name]
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

# Wait for certificate validation
resource "aws_acm_certificate_validation" "website" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

# -----------------------------------------------------------------------------
# CloudFront Distribution
# -----------------------------------------------------------------------------

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = concat([var.primary_domain], var.alternate_domains)
  price_class         = "PriceClass_100"  # Europe & North America
  comment             = "Ndmr Website"

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  # Cache behavior for static assets (longer cache)
  ordered_cache_behavior {
    path_pattern     = "/css/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 86400
    default_ttl            = 604800
    max_ttl                = 2592000
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern     = "/js/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 86400
    default_ttl            = 604800
    max_ttl                = 2592000
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 86400
    default_ttl            = 604800
    max_ttl                = 2592000
    compress               = true
  }

  # Custom error responses for SPA
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name        = "Ndmr Website"
    Environment = var.environment
  }

  depends_on = [aws_acm_certificate_validation.website]
}

# -----------------------------------------------------------------------------
# Route53 DNS Records for domains -> CloudFront
# -----------------------------------------------------------------------------

resource "aws_route53_record" "apex_a" {
  for_each = { for d in local.apex_domains : d => local.domain_zone_map[d] }

  zone_id = each.value
  name    = each.key
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  for_each = { for d in local.apex_domains : d => local.domain_zone_map[d] }

  zone_id = each.value
  name    = each.key
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  for_each = { for d in local.www_domains : d => local.domain_zone_map[d] }

  zone_id = each.value
  name    = each.key
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  for_each = { for d in local.www_domains : d => local.domain_zone_map[d] }

  zone_id = each.value
  name    = each.key
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

# -----------------------------------------------------------------------------
# Outputs for DNS configuration
# -----------------------------------------------------------------------------

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.website.arn
}

output "acm_validation_records" {
  description = "DNS records to add for certificate validation"
  value = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

output "dns_cname_record" {
  description = "CNAME record to add for each domain"
  value       = "Point all domains (${var.primary_domain}, ${join(", ", var.alternate_domains)}) to: ${aws_cloudfront_distribution.website.domain_name}"
}
