# S3 Bucket Names
order_confirmed_bucket_name = "order-confirmed-bucket"
order_cancelled_bucket_name = "order-cancelled-bucket"

# SQS Queue Names
order_confirmed_queue_name = "OrderConfirmedQueue"
order_cancelled_queue_name = "OrderCancelledQueue"

# IAM Role
confirmed_lambda_iam_role_name = "confirmed_lambda_role" 
cancelled_lambda_iam_role_name = "confirm_lambda_role"
# IAM Policy
cancelled_lambda_iam_policy_name = "cancelled_lambda_policy" 
confirmed_lambda_iam_policy_name = "confirmed_lambda_policy" 
# Lambda Function
runtime              = "python3.12"
architectures        = ["arm64"]
cancelled_handler = "cancelled-order.lambda_handler"
confirmed_handler = "confirmed-order.lambda_handler"
confirmed_order_lambda_function_name = "ConfirmedOrderLambda"
cancelled_order_lambda_function_name = "CancelledOrderLambda"

# SQS Configuration
visibility_timeout_seconds = 30
message_retention_seconds = 345600
dlq_message_retention_seconds = 1209600 
delay_seconds = 5
max_message_size = 262144 
receive_wait_time_seconds = 20 

# EventBridge Event Bus
event_bus_name = "OrderEventBus"
confirmed_order_rule_name = "ConfirmedOrderRule"
cancelled_order_rule_name = "CancelledOrderRule"
