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
  for_each = lookup(lookup(module.subnets, "public", null), "route_table_ids", null)
  route_table_id = each.value["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_eip" "ngw" {
  count = length(local.public_subnet_ids)
  domain = "vpc"
}

resource "aws_nat_gateway" "nwg" {
  count = length(local.public_subnet_ids)
  allocation_id = element(aws_eip.ngw.*.id, count.index )
  subnet_id     = element(local.public_subnet_ids, count.index )
}

resource "aws_route" "ngw" {
  count = length(local.private_subnet_ids)
  route_table_id = element(local.private_subnet_ids, count.index )
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.nwg.*.id, count.index )
}






# To fetch the output of subnets child module output.tf.
#output "subnets" {
#  value = module.subnets
#}

#output "all_subnets" {
#  value = var.all_subnets
#}