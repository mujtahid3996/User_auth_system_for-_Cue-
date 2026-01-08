resource "aws_cloudwatch_log_group" "user_pool_logs" {
  name              = "/aws/cognito/user_pool/${local.prefix}-user-pool-logs"
  retention_in_days = 7
  
}
