# ==============================================================================
# AWS Cognito User Pool - ইউজার অথেন্টিকেশন ডাটাবেস সেটআপ করার জন্য
# কাজ: 
#   - ইউজার রেজিস্ট্রেশন এবং ডাটা স্টোরেজ ম্যানেজ করে।
#   - ইমেল ভিত্তিক ইউজারনেম এবং অটো-ভেরিফিকেশন এনাবল করা হয়েছে।
#   - সিকিউর পাসওয়ার্ড পলিসি সেট করা হয়েছে (কমপক্ষে ৮টি অক্ষর, বড়-ছোট হাতের অক্ষর, সংখ্যা এবং সিম্বল)।
#   - পোস্ট-কনফার্মেশন লজিকের জন্য ল্যাম্বডা ফাংশন ইন্টিগ্রেশন করা হয়েছে।
#   - ভেরিয়েবলের মাধ্যমে MFA (Multi-Factor Authentication) সাপোর্ট এনাবল বা ডিজেবল করা যায়।
# ==============================================================================
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

# ==============================================================================
# AWS Cognito User Pool Client - অথেন্টিকেশন ক্রেডেনশিয়াল এবং API এক্সেস ম্যানেজ করার জন্য
# কাজ: 
#   - এটি ইউজার পুলের সাথে অ্যাপ্লিকেশনের সংযোগ স্থাপন করে।
#   - ফ্রন্টএন্ড বা মোবাইল অ্যাপের জন্য সিক্রেট জেনারেশন বন্ধ রাখা হয়েছে।
#   - সরাসরি পাসওয়ার্ড অথেন্টিকেশন এবং রিফ্রেশ টোকেন সাপোর্ট এনাবল করা হয়েছে।
# ==============================================================================
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                = "${local.prefix}-user-pool-client"
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  generate_secret     = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
