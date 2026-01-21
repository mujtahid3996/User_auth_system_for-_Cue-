# Cognito user confirmation-এর পর profile DynamoDB-তে সংরক্ষণ করে
# এবং SNS-এর মাধ্যমে welcome notification পাঠায়।
import json
import logging
import os
import boto3
from datetime import datetime, timezone

logger = logging.getLogger()
logger.setLevel(logging.INFO)

sns = boto3.client("sns")
dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    logger.info(f"Profile creation started for user: {json.dumps(event)}")
    user_id = event["userName"]
    email = event["request"]["userAttributes"]["email"]
    table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])
    table.put_item(Item={
        "user_id": user_id,
        "email": email,
        "createdAt": datetime.now(timezone.utc).isoformat()
    })
    sns.publish(
        TopicArn=os.environ["SNS_TOPIC_ARN"],
        Subject=f"Welcome to our system!",
        Message=json.dumps({
            "message": f"Hi {email} welcome to our system! Your registration is successful.",
            "user_id": user_id,
            "email": email
        }, indent=2)
    )

    logger.info(f"Notification sent for user {email }")

    return event