resource "aws_subnet" "main" {
  # And finally it will iterate 6 times to create 6 subnets
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags              = merge(var.tags, { Name = "${var.env}-${each.key}-subnet" })
}

resource "aws_route_table" "main" {
  for_each = var.subnets
  vpc_id   = var.vpc_id
  tags     = merge(var.tags, { Name = "${var.env}-${each.key}-rt" })
}

resource "aws_route_table_association" "main" {
  for_each       = var.subnets
  subnet_id      = lookup(lookup(aws_subnet.main, each.key, null), "id", null)
  route_table_id = lookup(lookup(aws_route_table.main, each.key, null), "id", null)
}






# We are using lookup function to find out the subnet and RT table id because both resources will generate the attribute and from those attribute we have to find out the values.


#output "subnets" {
#  value = var.subnets
#}