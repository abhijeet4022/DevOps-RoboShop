# VPC Variables
variable "vpc" {}
variable "tags" {}
variable "env" {}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}
variable "default_vpc_route_table_id" {}
variable "az" {}

# ALB Variables
variable "alb" {}
variable "acm_certificate_arn" {}

# DocumentDB

variable "docdb" {}
variable "kms_key_arn" {}

# Aurora_MYSQL

variable "rds" {}


# elasticache
variable "elasticache" {}

# RabbitMQ
variable "rabbitmq" {}
variable "zone_id" {}
variable "ssh_subnets_cidr" {}

# Application
variable "app" {}
variable "monitoring_ingress_cidr" {}

# Prometheus
variable "prometheus" {}
variable "internet_ingress_cidr" {}
