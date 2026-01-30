# Signup-এর পর welcome notification পাঠানোর SNS topic তৈরি করে।
resource "aws_sns_topic" "welcome_topic" {
  name = "${local.prefix}-signup-notifications"
}

# Welcome notification ইমেইলে পাওয়ার জন্য email subscription তৈরি করে।
# SNS থেকে পাঠানো confirmation email-এ subscriber-কে subscription নিশ্চিত করতে হবে।
resource "aws_sns_topic_subscription" "Welcome_email" {
  topic_arn = aws_sns_topic.welcome_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}