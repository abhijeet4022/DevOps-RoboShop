resource "aws_vpc" "main" {
  cidr_block       = var.vpc
  tags = {
    Name = "main"
  }
}

variable "vpc" {
  default = "10.0.0.0/16"
}