terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}

# Variables
variable "aws_region" {
  default = "eu-west-3"
}

variable "aws_profile" {
  default = "feraudet"
}

variable "environment" {
  default = "prod"
}

variable "jwt_secret" {
  description = "Secret key for JWT signing"
  sensitive   = true
}

variable "domain_name" {
  default = "api.ndmr.app"
}

locals {
  prefix = "ndmr-api-${var.environment}"
}

# -----------------------------------------------------------------------------
# DynamoDB Tables
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "users" {
  name         = "${local.prefix}-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  global_secondary_index {
    name            = "id-index"
    hash_key        = "id"
    projection_type = "ALL"
  }

  tags = {
    Name        = "${local.prefix}-users"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "codeplugs" {
  name         = "${local.prefix}-codeplugs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${local.prefix}-codeplugs"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "refresh_tokens" {
  name         = "${local.prefix}-refresh-tokens"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "token"

  attribute {
    name = "token"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "user-id-index"
    hash_key        = "user_id"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  tags = {
    Name        = "${local.prefix}-refresh-tokens"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# IAM Role for Lambda
# -----------------------------------------------------------------------------

resource "aws_iam_role" "lambda_role" {
  name = "${local.prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.users.arn,
          "${aws_dynamodb_table.users.arn}/index/*",
          aws_dynamodb_table.codeplugs.arn,
          "${aws_dynamodb_table.codeplugs.arn}/index/*",
          aws_dynamodb_table.refresh_tokens.arn,
          "${aws_dynamodb_table.refresh_tokens.arn}/index/*"
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# Lambda Functions
# -----------------------------------------------------------------------------

data "archive_file" "auth_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/auth_handler.py"
  output_path = "${path.module}/lambda/auth_handler.zip"
}

data "archive_file" "codeplugs_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/codeplugs_handler.py"
  output_path = "${path.module}/lambda/codeplugs_handler.zip"
}

resource "aws_lambda_function" "auth" {
  filename         = data.archive_file.auth_lambda.output_path
  function_name    = "${local.prefix}-auth"
  role             = aws_iam_role.lambda_role.arn
  handler          = "auth_handler.lambda_handler"
  source_code_hash = data.archive_file.auth_lambda.output_base64sha256
  runtime          = "python3.12"
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      USERS_TABLE          = aws_dynamodb_table.users.name
      REFRESH_TOKENS_TABLE = aws_dynamodb_table.refresh_tokens.name
      JWT_SECRET           = var.jwt_secret
      JWT_EXPIRY_MINUTES   = "60"
      REFRESH_EXPIRY_DAYS  = "30"
    }
  }

  tags = {
    Name        = "${local.prefix}-auth"
    Environment = var.environment
  }
}

resource "aws_lambda_function" "codeplugs" {
  filename         = data.archive_file.codeplugs_lambda.output_path
  function_name    = "${local.prefix}-codeplugs"
  role             = aws_iam_role.lambda_role.arn
  handler          = "codeplugs_handler.lambda_handler"
  source_code_hash = data.archive_file.codeplugs_lambda.output_base64sha256
  runtime          = "python3.12"
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      CODEPLUGS_TABLE = aws_dynamodb_table.codeplugs.name
      JWT_SECRET      = var.jwt_secret
    }
  }

  tags = {
    Name        = "${local.prefix}-codeplugs"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# API Gateway HTTP API
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_api" "api" {
  name          = "${local.prefix}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = [
      "https://ndmr.app",
      "https://ndmr.fr",
      "https://ndmr.eu",
      "https://www.ndmr.app",
      "https://www.ndmr.fr",
      "https://www.ndmr.eu",
      "http://localhost:3000",
      "http://localhost:5173",
      "http://localhost:8080"
    ]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 3600
  }

  tags = {
    Name        = local.prefix
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      responseLength = "$context.responseLength"
      errorMessage   = "$context.error.message"
    })
  }

  tags = {
    Name        = "${local.prefix}-default"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${local.prefix}"
  retention_in_days = 14
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "auth_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "codeplugs_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codeplugs.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Lambda integrations
resource "aws_apigatewayv2_integration" "auth" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.auth.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "codeplugs" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.codeplugs.invoke_arn
  payload_format_version = "2.0"
}

# Auth routes
resource "aws_apigatewayv2_route" "auth_register" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /auth/register"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

resource "aws_apigatewayv2_route" "auth_login" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /auth/login"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

resource "aws_apigatewayv2_route" "auth_refresh" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /auth/refresh"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

resource "aws_apigatewayv2_route" "auth_me" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /auth/me"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

# Codeplugs routes
resource "aws_apigatewayv2_route" "codeplugs_list" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /codeplugs"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

resource "aws_apigatewayv2_route" "codeplugs_get" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /codeplugs/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

resource "aws_apigatewayv2_route" "codeplugs_create" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /codeplugs"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

resource "aws_apigatewayv2_route" "codeplugs_update" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "PUT /codeplugs/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

resource "aws_apigatewayv2_route" "codeplugs_delete" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "DELETE /codeplugs/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

resource "aws_apigatewayv2_route" "codeplugs_sync" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /codeplugs/sync"
  target    = "integrations/${aws_apigatewayv2_integration.codeplugs.id}"
}

# -----------------------------------------------------------------------------
# Custom Domain
# -----------------------------------------------------------------------------

data "aws_route53_zone" "ndmr_app" {
  name = "ndmr.app."
}

resource "aws_acm_certificate" "api" {
  # For API Gateway HTTP API, certificate must be in the same region
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}

resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.ndmr_app.zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert_validation : record.fqdn]
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.api.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Name        = var.domain_name
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.default.id
}

resource "aws_route53_record" "api" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.ndmr_app.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "api_endpoint" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "api_custom_domain" {
  value = "https://${var.domain_name}"
}

output "users_table" {
  value = aws_dynamodb_table.users.name
}

output "codeplugs_table" {
  value = aws_dynamodb_table.codeplugs.name
}

output "refresh_tokens_table" {
  value = aws_dynamodb_table.refresh_tokens.name
}
