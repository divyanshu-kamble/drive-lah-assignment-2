# drive-lah-assignment-2

## Overview

This project demonstrates an event-driven architecture using AWS services. Events are sent to an EventBridge bus, where they are routed to SQS queues based on defined rules. SQS queues trigger Lambda functions, which process the data and store it in S3 buckets.

1. Send events to the EventBridge bus.
2. Monitor SQS queues for incoming messages based on the rules of event bus.
3. Invokes respecitve Lambda functions.
4. Stores the contents in S3 bucket.
