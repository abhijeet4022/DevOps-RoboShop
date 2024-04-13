
# To fetch the output of subnets child module output.tf.
#output "subnets" {
#  value = module.subnets
#}

#output "all_subnets" {
#  value = var.all_subnets
#}


# Sending the output
output "private_vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = module.subnets
}