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
