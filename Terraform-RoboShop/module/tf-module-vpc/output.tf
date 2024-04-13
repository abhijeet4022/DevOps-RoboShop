
# To fetch the output of subnets child module output.tf.
#output "subnets" {
#  value = module.subnets
#}

#output "all_subnets" {
#  value = var.all_subnets
#}

output "public_subnets_ids" {
  value = local.public_subnet_ids
}

# Sending the output
output "private_vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = module.subnets
}