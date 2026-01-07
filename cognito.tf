resource "aws_cognito_user_pool" "user_pool" {
  name = "${local.prefix}-user-pool"
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }
  lambda_config {
    post_confirmation = aws_lambda_function.functions.arn
  }
  mfa_configuration = var.enable_mfa ? "ON" : "OFF"
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                = "${local.prefix}-user-pool-client"
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  generate_secret     = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}