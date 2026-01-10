# Terraform configuration for Ndmr Feedback API
# API Gateway + Lambda for Slack webhook integration

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
  profile = "feraudet"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for #ndmr channel"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# ============================================
# Lambda Function
# ============================================

# Package Lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ndmr-feedback-lambda-role-${var.environment}"

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

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "feedback" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ndmr-feedback-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 10
  memory_size      = 128

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }

  tags = {
    Project     = "ndmr"
    Environment = var.environment
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.feedback.function_name}"
  retention_in_days = 14

  tags = {
    Project     = "ndmr"
    Environment = var.environment
  }
}

# ============================================
# API Gateway (HTTP API v2)
# ============================================

resource "aws_apigatewayv2_api" "feedback_api" {
  name          = "ndmr-feedback-api-${var.environment}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://ndmr.app", "https://ndmr.fr", "https://ndmr.eu", "https://www.ndmr.app", "https://www.ndmr.fr", "https://www.ndmr.eu", "http://localhost:3000", "http://localhost:5173", "http://localhost:8080"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["Content-Type"]
    max_age       = 300
  }

  tags = {
    Project     = "ndmr"
    Environment = var.environment
  }
}

# Lambda integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.feedback_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.feedback.invoke_arn
  integration_method = "POST"
}

# Route for POST /feedback
resource "aws_apigatewayv2_route" "feedback_route" {
  api_id    = aws_apigatewayv2_api.feedback_api.id
  route_key = "POST /feedback"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Default stage with auto-deploy
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.feedback_api.id
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
    })
  }

  tags = {
    Project     = "ndmr"
    Environment = var.environment
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/ndmr-feedback-${var.environment}"
  retention_in_days = 14

  tags = {
    Project     = "ndmr"
    Environment = var.environment
  }
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.feedback.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.feedback_api.execution_arn}/*/*"
}

# ============================================
# Outputs
# ============================================

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.feedback_api.api_endpoint
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.feedback.function_name
}

output "feedback_url" {
  description = "Full URL for feedback endpoint"
  value       = "${aws_apigatewayv2_api.feedback_api.api_endpoint}/feedback"
}
