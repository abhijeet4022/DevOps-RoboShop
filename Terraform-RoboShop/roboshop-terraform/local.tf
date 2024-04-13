locals {
  vpc_id      = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  app_subnets = [for k, v in lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), "app", null) : v.id
  ]
}
