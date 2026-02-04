# AWS resource-গুলো কোন region-এ তৈরি হবে তা নির্ধারণ করে।
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}