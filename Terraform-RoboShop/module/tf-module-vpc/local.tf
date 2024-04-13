# These are local variables
locals {
  # It will first find the whole subnets ids value and then using for we will filter only subnet id.
  # Subnets
  public_subnet_ids = [for k, v in lookup(lookup(module.subnets, "public", null), "subnet_ids", null) : v.id]
  app_subnet_ids    = [for k, v in lookup(lookup(module.subnets, "app", null), "subnet_ids", null) : v.id]
  db_subnet_ids     = [for k, v in lookup(lookup(module.subnets, "db", null), "subnet_ids", null) : v.id]
  # Now merge app and subnet to gather the four private subnet id.
  private_subnet_ids = concat(local.app_subnet_ids, local.db_subnet_ids)

  # Route Table
  public_route_table_id = [for k, v in lookup(lookup(module.subnets, "public", null), "route_table_ids", null) : v.id]
  app_route_table_id = [for k, v in lookup(lookup(module.subnets, "app", null), "route_table_ids", null) : v.id]
  db_route_table_id = [for k, v in lookup(lookup(module.subnets, "db", null), "route_table_ids", null) : v.id]
  private_route_table_id = concat(local.app_route_table_id, local.db_route_table_id)

  # Tags
  # Merging all the variables in one place local.tags
  tags = merge(var.tags, {tf-module-name = "vpc"}, {env = var.env})
}

