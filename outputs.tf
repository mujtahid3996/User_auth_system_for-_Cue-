# Terraform apply-এর পর তৈরি AWS resource-গুলোর দরকারি তথ্য দেখায়, যাতে সেগুলো দেখা বা অন্য কাজে reference করা যায়।
# Lambda function-এর ARN output হিসেবে দেখায়।
output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.functions.arn
}

# DynamoDB users table-এর নাম output হিসেবে দেখায়।
output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.auth_table.name
}

# CloudWatch failed-login alarm-এর নাম output হিসেবে দেখায়।
output "cloudwatch_alarm_name" {
  description = "CloudWatch alarm name"
  value       = aws_cloudwatch_metric_alarm.failed_login_alarm.alarm_name
}

# Failed-login alert পাঠানোর SNS topic-এর ARN output হিসেবে দেখায়।
output "alert_sns_topic_arn" {
  description = "alert topic ARN"
  value = aws_sns_topic.alert_topic.arn
}

# Welcome notification পাঠানোর SNS topic-এর ARN output হিসেবে দেখায়।
output "welcome_sns_topic_arn" {
  description = "welcome topic ARN"
  value = aws_sns_topic.welcome_topic.arn
}
