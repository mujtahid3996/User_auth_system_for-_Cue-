resource "aws_cloudwatch_log_group" "user_pool_logs" {
  name              = "/aws/cognito/user_pool/${local.prefix}-user-pool-logs"
  retention_in_days = 7
  
}
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