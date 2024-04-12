resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = {
    Name    = var.vpc_name
    Project = var.project_name
  }
}

module "subnets" {
  source = "./subnets"
  for_each = var.all_subnets
  subnets = each.value
}


output "all_subnets" {
  value = var.all_subnets
}