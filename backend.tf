terraform {
  backend "s3" {
    bucket = "terraform-state-533267105368"
    key    = "user-auth-system/terraform.tfstate"
    region = "ap-south-1"
  }
}