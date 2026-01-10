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
