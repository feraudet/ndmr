terraform {
  required_version = ">= 1.0"

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

  backend "s3" {
    bucket = "ndmr-terraform-state"
    key    = "backend/terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ndmr"
      Environment = var.environment
      ManagedBy   = "opentofu"
    }
  }
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
  default     = "prod"
}

variable "jwt_secret_key" {
  description = "Secret key for JWT signing"
  type        = string
  sensitive   = true
}

# DynamoDB Tables
resource "aws_dynamodb_table" "users" {
  name         = "ndmr-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "codeplugs" {
  name         = "ndmr-codeplugs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "user_id-index"
    hash_key        = "user_id"
    projection_type = "ALL"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ndmr-api-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "ndmr-api-lambda-policy"
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
          "${aws_dynamodb_table.codeplugs.arn}/index/*"
        ]
      }
    ]
  })
}

# Lambda Layer for dependencies
resource "null_resource" "pip_install" {
  triggers = {
    requirements = filemd5("${path.module}/../requirements.txt")
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/..
      rm -rf layer/python
      mkdir -p layer/python
      pip install -r requirements.txt -t layer/python --platform manylinux2014_aarch64 --only-binary=:all: --python-version 3.12
    EOT
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/../layer"
  output_path = "${path.module}/../layer.zip"

  depends_on = [null_resource.pip_install]
}

resource "aws_lambda_layer_version" "dependencies" {
  filename            = data.archive_file.layer.output_path
  layer_name          = "ndmr-api-dependencies"
  source_code_hash    = data.archive_file.layer.output_base64sha256
  compatible_runtimes = ["python3.12"]
  compatible_architectures = ["arm64"]
}

# Lambda Function
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/../lambda.zip"
}

resource "aws_lambda_function" "api" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "ndmr-api"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.12"
  architectures    = ["arm64"]
  memory_size      = 256
  timeout          = 30

  layers = [aws_lambda_layer_version.dependencies.arn]

  environment {
    variables = {
      ENVIRONMENT             = var.environment
      JWT_SECRET_KEY          = var.jwt_secret_key
      DYNAMODB_USERS_TABLE    = aws_dynamodb_table.users.name
      DYNAMODB_CODEPLUGS_TABLE = aws_dynamodb_table.codeplugs.name
      AWS_REGION              = var.aws_region
    }
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "ndmr-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = ["http://localhost:*", "https://ndmr.app", "https://*.ndmr.app"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers     = ["Content-Type", "Authorization"]
    allow_credentials = true
    max_age           = 86400
  }
}

resource "aws_apigatewayv2_stage" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/ndmr-api"
  retention_in_days = 14
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.api.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Outputs
output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = "${aws_apigatewayv2_api.api.api_endpoint}/${var.environment}"
}

output "users_table_name" {
  description = "DynamoDB Users table name"
  value       = aws_dynamodb_table.users.name
}

output "codeplugs_table_name" {
  description = "DynamoDB Codeplugs table name"
  value       = aws_dynamodb_table.codeplugs.name
}
