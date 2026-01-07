# ==============================================================================
# AWS CloudWatch Log Group - Cognito লগ সংরক্ষণের জন্য একটি log group তৈরি করে।
# Cognito User Pool থেকে এখানে লগ পাঠানোর configuration এই Terraform-এ নেই।
# ==============================================================================
resource "aws_cloudwatch_log_group" "user_pool_logs" {
  name              = "/aws/cognito/user_pool/${local.prefix}-user-pool-logs"
  retention_in_days = 7
  
}

# ==============================================================================
# AWS CloudWatch Metric Filter - ভুল লগইন চেষ্টা শনাক্ত এবং গণনা করার জন্য
# কাজ: এই log group-এ থাকা লগে "Failed authentication" স্ট্রিং খুঁজে পেলে
#       প্রতিটি মিলকে একটি মেট্রিক হিসেবে গণনা করে।
# ==============================================================================
resource "aws_cloudwatch_log_metric_filter" "failed_login_patterns" {
  name           = "${local.prefix}-failed-login-patterns"
  log_group_name = aws_cloudwatch_log_group.user_pool_logs.name
  pattern        = "Failed authentication"

  metric_transformation {
    name      = "${local.prefix}-failed-login-attempts"
    namespace = "CognitoUserPoolMetrics"
    value     = "1"
  }
  
}

# ==============================================================================
# AWS CloudWatch Metric Alarm - ভুল লগইন অ্যালার্ট সিস্টেম তৈরি করার জন্য
# কাজ: যদি এক মিনিটে ৩টি বা তার বেশি ভুল লগইন চেষ্টা দেখা যায়, তবে এটি 
#       স্বয়ংক্রিয়ভাবে SNS-এর মাধ্যমে নোটিফিকেশন পাঠাবে। এটি সিকিউরিটি ব্রিচ শনাক্ত করতে সাহায্য করে।
# ==============================================================================
resource "aws_cloudwatch_metric_alarm" "failed_login_alarm" {
  alarm_name          = "${local.prefix}-failed-login-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.failed_login_patterns.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.failed_login_patterns.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 3

  alarm_description   = "Alarm when there are more than 3 failed login attempts in a minute." 
  alarm_actions       = [aws_sns_topic.alert_topic.arn]
}
