# VPC Creation
module "vpc" {
  source                     = "../module/tf-module-vpc"
  for_each                   = var.vpc
  cidr                       = each.value["cidr"]
  vpc_name                   = each.value["vpc_name"]
  # it will all subnets [public, app, web]
  all_subnets                = each.value["subnets"]
  default_vpc_id             = var.default_vpc_id
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags                       = var.tags
  env                        = var.env
}


# ALB Creation
module "alb" {
  source             = "../module/tf-module-alb"
  for_each           = var.alb
  tags               = var.tags
  env                = var.env
  internal           = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]
  sg_ingress_cidr    = each.value["sg_ingress_cidr"]
  # condition ? true_val : false_val
  # private vpc id we will fetch by lookup func from output block of vpc module.
  vpc_id             = each.value["internal"] ? local.vpc_id : var.default_vpc_id
  subnets            = each.value["internal"] ? local.app_subnets : data.aws_subnets.subnets.ids
  sg_port            = each.value["sg_port"]
}


# DocumentDB Creation
module "docdb" {
  source = "../module/tf-module-docdb"
  tags   = var.tags
  env    = var.env

  for_each   = var.docdb
  subnet_ids = local.db_subnets_ids
  vpc_id = local.vpc_id
  db_sg_ingress_cidr = local.subnet_ids


}


