# AWS resource-গুলো কোন region-এ তৈরি হবে তা নির্ধারণ করে।
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# Welcome ও alert notification পাঠানোর email address নির্ধারণ করে।
variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
  sensitive   = true  
}

# Cognito User Pool-এ MFA চালু বা বন্ধ রাখে।
variable "enable_mfa" {
  description = "Enable MFA for the Cognito User Pool"