## VPC Creation
module "vpc" {
  source = "../module/tf-module-vpc"

  default_vpc_id             = var.default_vpc_id
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags                       = var.tags
  env                        = var.env

  for_each    = var.vpc
  cidr        = each.value["cidr"]
  vpc_name    = each.value["vpc_name"]
  all_subnets = each.value["subnets"]  # it will all subnets [public, app, web]

}


#
# ALB Creation
#module "alb" {
#  source = "../module/tf-module-alb"
#
#  tags = var.tags
#  env  = var.env
#
#  for_each           = var.alb
#  internal           = each.value["internal"]
#  load_balancer_type = each.value["load_balancer_type"]
#  sg_ingress_cidr    = each.value["sg_ingress_cidr"]
#  # condition ? true_val : false_val
#  # private vpc id we will fetch by lookup func from output block of vpc module.
#  vpc_id             = each.value["internal"] ? local.vpc_id : var.default_vpc_id
#  subnets            = each.value["internal"] ? local.app_subnets : data.aws_subnets.subnets.ids
#  sg_port            = each.value["sg_port"]
#}


## DocumentDB Creation
#module "docdb" {
#  source = "../module/tf-module-docdb"
#  tags   = var.tags
#  env    = var.env
#
#  for_each                = var.docdb
#  vpc_id                  = local.vpc_id
#  db_subnets_ids          = local.db_subnets_ids
#  app_subnets_cidr        = local.app_subnets_cidr
#  engine_family           = each.value["engine_family"]
#  backup_retention_period = each.value["backup_retention_period"]
#  preferred_backup_window = each.value["preferred_backup_window"]
#  skip_final_snapshot     = each.value["skip_final_snapshot"]
#  engine_version          = each.value["engine_version"]
#  instance_count          = each.value["instance_count"]
#  instance_class          = each.value["instance_class"]
#}

## Aurora_MYSQL RDS Creation.
#module "rds" {
#  source = "../module/tf-module-rds"
#  tags   = var.tags
#  env    = var.env
#
#  for_each                = var.rds
#  vpc_id                  = local.vpc_id
#  db_subnets_ids          = local.db_subnets_ids
#  app_subnets_cidr        = local.app_subnets_cidr
#  backup_retention_period = each.value["backup_retention_period"]
#  engine                  = each.value["engine"]
#  engine_version          = each.value["engine_version"]
#  family                  = each.value["family"]
#  instance_class          = each.value["instance_class"]
#  instance_count          = each.value["instance_count"]
#  preferred_backup_window = each.value["preferred_backup_window"]
#  rds_type                = each.value["rds_type"]
#  sg_port                 = each.value["sg_port"]
#  skip_final_snapshot     = each.value["skip_final_snapshot"]
#}
#
## ElastiCache Cluster Creation.
#module "elasticache" {
#  source = "../module/tf-module-elasticache"
#  tags   = var.tags
#  env    = var.env
#
#  for_each         = var.elasticache
#  vpc_id           = local.vpc_id
#  db_subnets_ids   = local.db_subnets_ids
#  app_subnets_cidr = local.app_subnets_cidr
#  elasticache_type = each.value["elasticache_type"]
#  engine           = each.value["engine"]
#  engine_version   = each.value["engine_version"]
#  family           = each.value["family"]
#  node_type        = each.value["node_type"]
#  num_cache_nodes  = each.value["num_cache_nodes"]
#  sg_port          = each.value["sg_port"]
#}



# RabbitMQ Instance Creation.
#module "rabbitmq" {
#  source = "../module/tf-module-rabbitmq"
#
#  tags             = var.tags
#  env              = var.env
#  zone_id          = var.zone_id
#  ssh_subnets_cidr = var.ssh_subnets_cidr
#
#  for_each      = var.rabbitmq
#  instance_type = each.value["instance_type"]
#  sg_port       = each.value["sg_port"]
#
#  vpc_id           = local.vpc_id
#  db_subnets_ids   = local.db_subnets_ids
#  app_subnets_cidr = local.app_subnets_cidr
#
#}


# Application Setup
module "app" {
  source = "../module/tf-module-app"

  tags             = var.tags
  env              = var.env
  zone_id          = var.zone_id
  ssh_subnets_cidr = var.ssh_subnets_cidr

  for_each      = var.app
  component     = each.key
  sg_port       = each.value["sg_port"]
  instance_type = each.value["instance_type"]

  vpc_id           = local.vpc_id
  app_subnets_cidr = local.app_subnets_cidr
}


