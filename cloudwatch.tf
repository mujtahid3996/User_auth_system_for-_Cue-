# ==============================================================================
# AWS CloudWatch Log Group - Cognito User Pool-এর অ্যাক্টিভিটি ট্র্যাক করার জন্য
# কাজ: ইউজার পুলের লগইন, লগআউট এবং পাসওয়ার্ড রিসেটের মতো সব ইভেন্ট এখানে স্টোর হয়।
# ==============================================================================
resource "aws_cloudwatch_log_group" "user_pool_logs" {
  name              = "/aws/cognito/user_pool/${local.prefix}-user-pool-logs"
  retention_in_days = 7
  
}

# ==============================================================================
# AWS CloudWatch Metric Filter - ভুল লগইন চেষ্টা শনাক্ত এবং গণনা করার জন্য
# কাজ: লগ ফাইলের ভেতর থেকে "Failed authentication" স্ট্রিংটি খুঁজে বের করে 
#       সেটিকে একটি মেট্রিক হিসেবে কাউন্ট করে।
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
