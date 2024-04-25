variable "env" {}
variable "tags" {}
variable "component" {}
variable "zone_id" {}

variable "vpc_id" {}
variable "app_subnets_cidr" {}
variable "ssh_subnets_cidr" {}
variable "sg_port" {}

variable "instance_type" {}


variable "app_subnets_ids" {}
variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}

variable "private_alb_name" {}
variable "private_listener" {}
variable "public_alb_name" {}

variable "default_vpc_id" {}
variable "priority" {}



