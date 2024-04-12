resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags              = {
    Name    = "${each.key}-subnet"
    Project = "roboshop"
  }
}

resource "aws_route_table" "main" {
  for_each = var.subnets
  vpc_id   = var.vpc_id
  tags     = {
    Name    = "${each.key}-rt"
    Project = "roboshop"
  }
}

resource "aws_route_table_association" "main" {
  for_each = var.subnets
  subnet_id      = lookup(lookup(aws_subnet.main, each.key, null), "id" , null)
  route_table_id = lookup(lookup(aws_route_table_association.main, each.key, null), "id" , null)
}

# We are using lookup function to find out the subnet and RT table id because both resources will generate the attribute and from those attribute we have to find out the values.


#output "subnets" {
#  value = var.subnets
#}