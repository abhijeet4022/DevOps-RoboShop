resource "aws_vpc" "main" {
  cidr_block = var.vpc
  tags       = {
    Name    = var.vpc_name
    Project = var.project_name
  }
}
