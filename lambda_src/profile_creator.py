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


