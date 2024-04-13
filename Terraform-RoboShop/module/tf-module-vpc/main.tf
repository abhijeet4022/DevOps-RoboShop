resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = merge(local.tags, { Name = "${var.env}-vpc" })
}

module "subnets" {
  source   = "./subnets"
  # so there are subnet it will iterate three time
  for_each = var.all_subnets
  # Every subnet having again two subnet so total six it will consider all six subnets.
  subnets  = each.value
  vpc_id   = aws_vpc.main.id
  env      = var.env
  tags     = local.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.tags, { Name = "${var.env}-igw" })
}

resource "aws_route" "igw" {
  for_each               = lookup(lookup(module.subnets, "public", null), "route_table_ids", null)
  route_table_id         = each.value["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "ngw" {
  count  = length(local.public_subnet_ids)
  domain = "vpc"
  tags   = merge(local.tags, { Name = "${var.env}-ngw-eip-${count.index + 1}" })
}

resource "aws_nat_gateway" "ngw" {
  count         = length(local.public_subnet_ids)
  # This will fetch the two EIP from above.
  allocation_id = element(aws_eip.ngw.*.id, count.index)
  subnet_id     = element(local.public_subnet_ids, count.index)
  tags          = merge(local.tags, { Name = "${var.env}-public-ngw-${count.index + 1}" })
}

resource "aws_route" "ngw" {
  count                  = length(local.private_route_table_id)
  route_table_id         = element(local.private_route_table_id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)
}


resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id = aws_vpc.main.id
  vpc_id      = var.default_vpc_id
  auto_accept = true
  tags        = merge(local.tags, { Name = "${var.env}-peering" })
}


resource "aws_route" "peer" {
  count                     = length(local.private_route_table_id)
  route_table_id            = element(local.private_route_table_id, count.index)
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default-vpc-peer-entry" {
  route_table_id            = var.default_vpc_route_table_id
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

