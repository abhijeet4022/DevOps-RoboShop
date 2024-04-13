resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = {
    Name    = var.vpc_name
    Project = var.project_name
  }
}

module "subnets" {
  source   = "./subnets"
  # so there are subnet it will iterate three time
  for_each = var.all_subnets
  # Every subnet having again two subnet so total six it will consider all six subnets.
  subnets  = each.value
  vpc_id   = aws_vpc.main.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = {
    Name = "main-igw"
  }
}


#output "all_subnets" {
#  value = var.all_subnets
#}