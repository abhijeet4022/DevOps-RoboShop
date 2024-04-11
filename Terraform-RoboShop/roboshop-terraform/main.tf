module "network" {
  source   = "../module/tf-module-vpc"
  for_each = var.vpc
  vpc      = each.value["cidr"]
  name = each.value["name"]

}

