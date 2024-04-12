#resource "aws_subnet" "main" {
#  for_each = var.subnets
#  vpc_id = ""
#  cidr_block = each.value["cidr"]
#  availability_zone = each.value["az"]
#}

variable "subnets" {}

output "subnets" {
  value = var.subnets
}