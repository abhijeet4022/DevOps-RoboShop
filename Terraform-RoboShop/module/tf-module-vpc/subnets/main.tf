resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = "${each.key}-subnet"
    Project = "roboshop"
  }
}



#output "subnets" {
#  value = var.subnets
#}