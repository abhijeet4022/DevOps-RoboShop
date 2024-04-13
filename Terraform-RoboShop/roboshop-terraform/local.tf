locals {
  vpc_id      = lookup(lookup(module.vpc, "roboshop-vpc", null), "vpc_id", null)
  app_subnets = [for k, v in lookup(lookup(lookup(module.vpc, "roboshop-vpc", null ), "subnets", null), "subnet_ids", null) :v.id
  ]
}
