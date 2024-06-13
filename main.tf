data "aws_caller_identity" "current" {}

locals {
    aws_account_id = data.aws_caller_identity.current.account_id
}

module "s3_order_confirmed_bucket" {
  source      = "./modules/storage/s3/"
  bucket_name = var.order_confirmed_bucket_name
  versioning  = false
}

module "s3_order_cancelled_bucket" {
  source      = "./modules/storage/s3/"
  bucket_name = var.order_cancelled_bucket_name
}


# SQS Queues
module "order_confirmed_queue" {
  source = "./modules/sqs/"

  name                       = var.order_confirmed_queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.dlq_message_retention_seconds
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  receive_wait_time_seconds  = var.receive_wait_time_seconds
}

resource "aws_sqs_queue_policy" "order_confirmed_queue_policy" {
  queue_url = module.order_confirmed_queue.queue_id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "__owner_statement",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.aws_account_id}:root"
        },
        "Action" : "SQS:*",
        "Resource" : module.order_confirmed_queue.queue_arn
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sqs:SendMessage",
        "Resource" : module.order_confirmed_queue.queue_arn,
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : aws_cloudwatch_event_rule.confirmed_order_rule.arn
          }
        }
      }
    ]
  })
}

module "order_cancelled_queue" {
  source = "./modules/sqs/"
  name                       = var.order_cancelled_queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.dlq_message_retention_seconds
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  receive_wait_time_seconds  = var.receive_wait_time_seconds
}

resource "aws_sqs_queue_policy" "order_cancelled_queue_policy" {
  queue_url = module.order_cancelled_queue.queue_id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "__owner_statement",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.aws_account_id}:root"
        },
        "Action" : "SQS:*",
        "Resource" : module.order_cancelled_queue.queue_arn
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sqs:SendMessage",
        "Resource" : module.order_cancelled_queue.queue_arn,
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : aws_cloudwatch_event_rule.cancelled_order_rule.arn
          }
        }
      }
    ]
  })
}

# IAM Role and Policy for Lambda
module "confirmed_lambda_iam_role" {
  source = "./modules/identity-access-management/iam-roles/"
  name   = var.confirmed_lambda_iam_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

module "confirmed_lambda_iam_policy" {
  source = "./modules/identity-access-management/iam-policy/"
  name   = var.confirmed_lambda_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::order-*/*"
      },
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:us-east-1:${local.aws_account_id}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = [
          "arn:aws:logs:us-east-1:${local.aws_account_id}:log-group:/aws/lambda/${module.confirmed_order_lambda.lambda_function_name}:*"
        ]
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Effect   = "Allow",
        Resource = [
          module.order_confirmed_queue.queue_arn
        ]
      }
    ]
  })
  depends_on = [module.order_confirmed_queue]
}

module "cancelled_lambda_iam_role" {
  source = "./modules/identity-access-management/iam-roles/"
  name   = var.cancelled_lambda_iam_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

module "cancelled_lambda_iam_policy" {
  source = "./modules/identity-access-management/iam-policy/"
  name   = var.cancelled_lambda_iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::order-*/*"
      },
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:us-east-1:${local.aws_account_id}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = [
          "arn:aws:logs:us-east-1:${local.aws_account_id}:log-group:/aws/lambda/${module.cancelled_order_lambda.lambda_function_name}:*"
        ]
      },
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Effect   = "Allow",
        Resource = [
          module.order_cancelled_queue.queue_arn
        ]
      }
    ]
  })
  depends_on = [module.order_cancelled_queue]
}

#Attach policies to the role
module "confirmed_lambda_iam_role_policy_attachment" {
  source     = "./modules/identity-access-management/iam-role-policy-attachment/"
  role       = module.confirmed_lambda_iam_role.iam-role-name
  policy_arn = module.confirmed_lambda_iam_policy.iam-policy-arn
}

module "cancelled_lambda_iam_role_policy_attachment" {
  source     = "./modules/identity-access-management/iam-role-policy-attachment/"
  role       = module.cancelled_lambda_iam_role.iam-role-name
  policy_arn = module.cancelled_lambda_iam_policy.iam-policy-arn
}

#Lambda Function to Handle Both Confirmed and Cancelled Orders
module "confirmed_order_lambda" {
  source        = "./modules/lambda/"
  iam_role     = module.confirmed_lambda_iam_role.iam-role-arn
  function_name = var.confirmed_order_lambda_function_name
  handler       = var.confirmed_handler
  runtime       = var.runtime
  architectures = var.architectures
  filename      = "./lambda_function/confirmed_order/confirmed_lambda.zip"
}

module "cancelled_order_lambda" {
  source        = "./modules/lambda/"
  iam_role     = module.cancelled_lambda_iam_role.iam-role-arn
  function_name = var.cancelled_order_lambda_function_name
  handler       = var.cancelled_handler
  runtime       = var.runtime
  architectures = var.architectures
  filename      = "./lambda_function/cancelled_order/cancelled_lambda.zip"
}

# EventBridge Event Bus
resource "aws_cloudwatch_event_bus" "order_event_bus" {
  name = "OrderEventBus"
}

# EventBridge Rule for Confirmed Orders
resource "aws_cloudwatch_event_rule" "confirmed_order_rule" {
  name = "ConfirmedOrderRule"
  event_bus_name = aws_cloudwatch_event_bus.order_event_bus.name
  event_pattern = jsonencode({
    source = ["custom.orders"],
    detail-type = ["OrderEvent"],
    detail = {
      status = ["confirmed"]
    }
  })
}

# EventBridge Rule for Cancelled Orders
resource "aws_cloudwatch_event_rule" "cancelled_order_rule" {
  name = "CancelledOrderRule"
  event_bus_name = aws_cloudwatch_event_bus.order_event_bus.name
  event_pattern = jsonencode({
    source = ["custom.orders"],
    detail-type = ["OrderEvent"],
    detail = {
      status = ["cancelled"]
    }
  })
}

# EventBridge Targets
resource "aws_cloudwatch_event_target" "confirmed_order_target" {
  rule      = aws_cloudwatch_event_rule.confirmed_order_rule.name
  arn       = module.order_confirmed_queue.queue_arn
  event_bus_name = aws_cloudwatch_event_bus.order_event_bus.name
}

resource "aws_cloudwatch_event_target" "cancelled_order_target" {
  rule      = aws_cloudwatch_event_rule.cancelled_order_rule.name
  arn       = module.order_cancelled_queue.queue_arn
  event_bus_name = aws_cloudwatch_event_bus.order_event_bus.name
}

# Lambda Trigger for SQS
resource "aws_lambda_event_source_mapping" "confirmed_order_lambda_trigger" {
  event_source_arn = module.order_confirmed_queue.queue_arn
  function_name    = module.confirmed_order_lambda.lambda_function_arn
}

resource "aws_lambda_event_source_mapping" "cancelled_order_lambda_trigger" {
  event_source_arn = module.order_cancelled_queue.queue_arn
  function_name    = module.cancelled_order_lambda.lambda_function_arn
}



