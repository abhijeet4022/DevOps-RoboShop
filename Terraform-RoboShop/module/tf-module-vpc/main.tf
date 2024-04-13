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

resource "aws_route" "igw" {
  for_each = module.subnets["public"]["route_table_ids"]
  route_table_id = each.value["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}




# To fetch the output of subnets child module output.tf.
output "subnets" {
  value = module.subnets
}

#output "all_subnets" {
#  value = var.all_subnets
#}