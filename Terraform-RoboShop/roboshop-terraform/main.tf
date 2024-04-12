module "vpc" {
  source       = "../module/tf-module-vpc"
  for_each     = var.vpc
  cidr         = each.value["cidr"]
  vpc_name     = each.value["vpc_name"]
  project_name = var.project_name

  all_subnets      = each.value["subnets"]
}



#output "subnets" {
#  value = var.vpc["roboshop-vpc"]["subnets"]
#}
#output "cidr" {
#  value = var.vpc["roboshop-vpc"]["cidr"]
#}
