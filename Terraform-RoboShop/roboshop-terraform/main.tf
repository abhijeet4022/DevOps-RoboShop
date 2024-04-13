module "vpc" {
  source         = "../module/tf-module-vpc"
  for_each       = var.vpc
  cidr           = each.value["cidr"]
  vpc_name       = each.value["vpc_name"]
  project_name   = var.project_name
  # it will all subnets [public, app, web]
  all_subnets    = each.value["subnets"]
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
}


# This value will come from tf-module-vpc main.tf output block
output "vpc" {
  value = module.vpc
}


#output "subnets" {
#  value = var.vpc["roboshop-vpc"]["subnets"]
#}
#output "cidr" {
#  value = var.vpc["roboshop-vpc"]["cidr"]
#}
