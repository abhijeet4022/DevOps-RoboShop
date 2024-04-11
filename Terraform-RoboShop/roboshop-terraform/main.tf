module "network" {
  source   = "../module/tf-module-vpc"
  for_each = var.vpc
  vpc      = each.value["cidr"]
  vpcname = each.value["vpcname"]

}

