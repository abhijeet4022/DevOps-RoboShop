module "network" {
  source       = "../module/tf-module-vpc"
  for_each     = var.vpc
  vpc          = each.value["cidr"]
  vpc_name     = each.value["vpc_name"]
  project_name = var.project_name
}

