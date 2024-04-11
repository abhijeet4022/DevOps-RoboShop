resource "aws_vpc" "main" {
  cidr_block = var.vpc
  tags       = {
    Name = var.name
  }
}
