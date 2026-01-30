# Signup-এর পর welcome notification পাঠানোর SNS topic তৈরি করে।
resource "aws_sns_topic" "welcome_topic" {
  name = "${local.prefix}-signup-notifications"
}