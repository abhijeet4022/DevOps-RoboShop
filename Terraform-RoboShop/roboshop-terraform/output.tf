# This value will come from tf-module-vpc main.tf output block
output "vpc" {
  value = "module.vpc"
}


#output "subnets" {
#  value = var.vpc["roboshop-vpc"]["subnets"]
#}
#output "cidr" {
#  value = var.vpc["roboshop-vpc"]["cidr"]
#}

#output "app_subnet" {
#  value = local.app_subnets
#}

