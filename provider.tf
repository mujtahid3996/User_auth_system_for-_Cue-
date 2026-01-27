# Terraform ও প্রয়োজনীয় provider-গুলোর configuration রাখে।
terraform {
  required_version = ">= 1.0"

  # এই configuration-এ ব্যবহৃত provider-গুলোর source ও version নির্ধারণ করে।
  required_providers {

    # AWS provider-এর source ও version constraint নির্ধারণ করে।
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # Archive provider-এর source ও version constraint নির্ধারণ করে।
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

# AWS provider-এর deployment configuration সেট করে।
provider "aws" {
  region = var.aws_region

  # এই provider দিয়ে তৈরি AWS resource-গুলোতে স্বয়ংক্রিয়ভাবে default tags যোগ করে।
  default_tags {

