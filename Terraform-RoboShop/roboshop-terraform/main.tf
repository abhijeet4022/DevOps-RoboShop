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
## ALB Creation
#module "alb" {
#  source = "../module/tf-module-alb"
#
#  tags                = var.tags
#  env                 = var.env
#  acm_certificate_arn = var.acm_certificate_arn
#
#  for_each           = var.alb
#  internal           = each.value["internal"]
#  load_balancer_type = each.value["load_balancer_type"]
#  sg_ingress_cidr    = each.value["sg_ingress_cidr"]
#  # condition ? true_val : false_val
#  # private vpc id we will fetch by lookup func from output block of vpc module.
#  vpc_id             = each.value["internal"] ? local.vpc_id : var.default_vpc_id
#  subnets            = each.value["internal"] ? local.app_subnets_ids : data.aws_subnets.subnets.ids
#  sg_port            = each.value["sg_port"]
#}


# DocumentDB Creation
module "docdb" {
  source = "../module/tf-module-docdb"

  tags        = var.tags
  env         = var.env
  kms_key_arn = var.kms_key_arn

  for_each                = var.docdb
  engine_family           = each.value["engine_family"]
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  engine_version          = each.value["engine_version"]
  instance_count          = each.value["instance_count"]
  instance_class          = each.value["instance_class"]

  vpc_id           = local.vpc_id
  db_subnets_ids   = local.db_subnets_ids
  app_subnets_cidr = local.app_subnets_cidr
}

# Aurora_MYSQL RDS Creation.
module "rds" {
  source = "../module/tf-module-rds"

  tags        = var.tags
  env         = var.env
  kms_key_arn = var.kms_key_arn

  for_each                = var.rds
  backup_retention_period = each.value["backup_retention_period"]
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]
  family                  = each.value["family"]
  instance_class          = each.value["instance_class"]
  instance_count          = each.value["instance_count"]
  preferred_backup_window = each.value["preferred_backup_window"]
  rds_type                = each.value["rds_type"]
  sg_port                 = each.value["sg_port"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]

  vpc_id           = local.vpc_id
  db_subnets_ids   = local.db_subnets_ids
  app_subnets_cidr = local.app_subnets_cidr
}

# ElastiCache Cluster Creation.
module "elasticache" {
  source = "../module/tf-module-elasticache"

  tags = var.tags
  env  = var.env

  for_each         = var.elasticache
  elasticache_type = each.value["elasticache_type"]
  engine           = each.value["engine"]
  engine_version   = each.value["engine_version"]
  family           = each.value["family"]
  node_type        = each.value["node_type"]
  num_cache_nodes  = each.value["num_cache_nodes"]
  sg_port          = each.value["sg_port"]

  vpc_id           = local.vpc_id
  db_subnets_ids   = local.db_subnets_ids
  app_subnets_cidr = local.app_subnets_cidr
}


# RabbitMQ Instance Creation.
module "rabbitmq" {
  source = "../module/tf-module-rabbitmq"

  tags             = var.tags
  env              = var.env
  zone_id          = var.zone_id
  ssh_subnets_cidr = var.ssh_subnets_cidr
  kms_key_arn      = var.kms_key_arn

  for_each      = var.rabbitmq
  instance_type = each.value["instance_type"]
  sg_port       = each.value["sg_port"]


  vpc_id           = local.vpc_id
  db_subnets_ids   = local.db_subnets_ids
  app_subnets_cidr = local.app_subnets_cidr

}


## Application Setup
#module "app" {
#  depends_on = [module.docdb, module.elasticache, module.rabbitmq, module.rds, module.alb]
#  source     = "../module/tf-module-app"
#
#
#  tags                    = merge(var.tags, each.value["tags"])
#  env                     = var.env
#  zone_id                 = var.zone_id
#  ssh_subnets_cidr        = var.ssh_subnets_cidr
#  default_vpc_id          = var.default_vpc_id
#  monitoring_ingress_cidr = var.monitoring_ingress_cidr
#  az                      = var.az
#  kms_key_arn             = var.kms_key_arn
#
#  for_each         = var.app
#  component        = each.key
#  sg_port          = each.value["sg_port"]
#  instance_type    = each.value["instance_type"]
#  desired_capacity = each.value["desired_capacity"]
#  max_size         = each.value["max_size"]
#  min_size         = each.value["min_size"]
#  priority         = each.value["priority"]
#  parameters       = each.value["parameters"]
#
#  vpc_id           = local.vpc_id
#  app_subnets_cidr = local.app_subnets_cidr
#  app_subnets_ids  = local.app_subnets_ids
#
#  private_alb_name = lookup(lookup(lookup(module.alb, "private", null), "alb", null), "dns_name", null)
#  private_listener = lookup(lookup(lookup(module.alb, "private", null), "listener", null), "arn", null)
#  public_alb_name  = lookup(lookup(lookup(module.alb, "public", null), "alb", null), "dns_name", null)
#  public_listener  = lookup(lookup(lookup(module.alb, "public", null), "listener", null), "arn", null)
#}

## Create Instance for load test
#resource "aws_instance" "load_runner" {
#  ami                    = data.aws_ami.ami.id
#  instance_type          = "t3.small"
#  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
#  tags                   = { Name = "load-Runner" }
#
#}

# Prometheus Instance Creation.
#module "prometheus" {
#  source = "../module/tf-module-prometheus"
#
#  internet_ingress_cidr = var.internet_ingress_cidr
#  tags                  = var.tags
#  default_vpc_id        = var.default_vpc_id
#  env                   = var.env
#
#  for_each      = var.prometheus
#  instance_type = each.value["instance_type"]
#  from_port     = each.value["from_port"]
#  to_port       = each.value["to_port"]
#  component     = each.key
#}


# EKS Setup

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "prod-roboshop"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = local.vpc_id
  subnet_ids               = local.app_subnets_ids
  control_plane_subnet_ids = local.app_subnets_ids


  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = var.tags
}

# Security group 443 port opening for EKS to access EKS from workstation
resource "aws_security_group_rule" "https-to-eks-from-workstation" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = module.eks.cluster_security_group_id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = var.ssh_subnets_cidr
}

# security_group_id = module.eks.cluster_security_group_id  -- This cluster_security_group_id will defined in main module

# IAM PolicyFor EKS.
resource "aws_iam_role" "eks-ssm" {
  name = "${var.env}-eks-ssm-ro"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "${var.env}-eks-ssm-ro"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt",
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "ssm:DescribeParameters",
          "Resource" : "*"
        }
      ]
    })
  }

}