variable "order_confirmed_bucket_name" {
  description = "The name of the S3 bucket for confirmed orders"
  default     = "order-confirmed-bucket"
}

variable "order_cancelled_bucket_name" {
  description = "The name of the S3 bucket for cancelled orders"
  default     = "order-cancelled-bucket"
}

#SQS
variable "order_confirmed_queue_name" {
  description = "The name of the SQS queue for confirmed orders"
  default     = "OrderConfirmedQueue"
}

variable "order_cancelled_queue_name" {
  description = "The name of the SQS queue for cancelled orders"
  default     = "OrderCancelledQueue"
}

# Variables for IAM Role
variable "lambda_iam_role_name" {
  description = "The name of the IAM role for the Lambda function"
  type        = string
}

# Variables for IAM Policy
variable "lambda_iam_policy_name" {
  description = "The name of the IAM policy for the Lambda function"
  type        = string
}

#Lambda
variable "order_handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "architectures" {
  description = "The underlying architecture"
  type        = list(string)
}

variable "lambda_execution_role_name" {
  description = "The name of the IAM role for Lambda execution"
  default     = "lambda_execution_role"
}

variable "handle_order_lambda_function_name" {
  description = "The name of the Lambda function to handle orders"
  default     = "HandleOrderLambda"
}

#SQS
variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the SQS dead letter queue in seconds"
  type        = number
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
}

variable "dlq_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  type        = number
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive"
  type        = number
}

#Event_bus
variable "event_bus_name" {
  description = "The name of the EventBridge event bus"
  default     = "OrderEventBus"
}

variable "confirmed_order_rule_name" {
  description = "The name of the EventBridge rule for confirmed orders"
  default     = "ConfirmedOrderRule"
}

variable "cancelled_order_rule_name" {
  description = "The name of the EventBridge rule for cancelled orders"
  default     = "CancelledOrderRule"
}
