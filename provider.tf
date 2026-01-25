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

