# tfstate file
terraform {
  backend "s3" {
    bucket = "learntechnology.cloud"
    key    = "aws-parameters/terraform.tfstate"
    region = "us-east-1"
  }
}