# VPC Variables
variable "vpc" {}
variable "tags" {}
variable "env" {}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}
variable "default_vpc_route_table_id" {}

# ALB Variables
variable "alb" {}

# DocumentDB

variable "docdb" {}

# Aurora_MYSQL

variable "rds" {}


# elasticache
variable "elasticache" {}

# RabbitMQ
variable "rabbitmq" {}
variable "zone_id" {}