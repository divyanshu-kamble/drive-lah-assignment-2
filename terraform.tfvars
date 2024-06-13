# S3 Bucket Names
order_confirmed_bucket_name = "order-confirmed-bucket"
order_cancelled_bucket_name = "order-cancelled-bucket"

# SQS Queue Names
order_confirmed_queue_name = "OrderConfirmedQueue"
order_cancelled_queue_name = "OrderCancelledQueue"

# IAM Role
lambda_iam_role_name = "lambda_iam_role" # Replace with your IAM role name

# IAM Policy
lambda_iam_policy_name = "lambda_iam_policy" # Replace with your IAM policy name

# Lambda Function
runtime              = "python3.12"
architectures        = ["arm64"]
order_handler = "handle_order.lambda_handler"
handle_order_lambda_function_name = "HandleOrderLambda"

# SQS Configuration
visibility_timeout_seconds = 30 # Replace with your visibility timeout in seconds
message_retention_seconds = 345600 # Replace with your message retention in seconds
dlq_message_retention_seconds = 1209600 # Replace with your DLQ message retention in seconds
delay_seconds = 5 # Replace with your delay in seconds
max_message_size = 262144 # Replace with your max message size in bytes
receive_wait_time_seconds = 20 # Replace with your receive wait time in seconds

# EventBridge Event Bus
event_bus_name = "OrderEventBus"
confirmed_order_rule_name = "ConfirmedOrderRule"
cancelled_order_rule_name = "CancelledOrderRule"
