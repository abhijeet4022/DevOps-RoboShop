locals {
  vpc_id      = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  app_subnets = [for k, v in lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), "app", null), "subnet_ids", null) : v.id
  ]
  db_subnets_ids = [for k, v in lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), "db", null), "subnet_ids", null) : v.id
  ]
  subnet_ids = [for k, v in lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), "db", null), "subnet_ids", null) : v.cidr_block
  ]
}
