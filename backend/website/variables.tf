# Variables for Ndmr Website Infrastructure

variable "aws_region" {
  description = "AWS region for S3 bucket"
  type        = string
  default     = "eu-west-3"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "bucket_name" {
  description = "S3 bucket name for website content"
  type        = string
}

variable "primary_domain" {
  description = "Primary domain name"
  type        = string
}

variable "alternate_domains" {
  description = "Alternate domain names"
  type        = list(string)
  default     = []
}
