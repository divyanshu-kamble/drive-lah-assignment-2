import json
import boto3

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Extract the status field from the event
    lambda_event = json.loads(event['Records'][0]['body'])
    
    # Access the status details from the event
    order_id = lambda_event['detail']['orderId']
    
    bucket_name = 'order-cancelled-bucket'
    
    
    s3.put_object(
        Bucket=bucket_name,
        Key=f'orders/{order_id}.json',
        Body=json.dumps(event)
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Order processed successfully')
    }
