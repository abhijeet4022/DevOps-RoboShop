locals {
  tags     = merge(var.tags, { tf-module-name = "alb" }, { env = var.env })
  alb_name = var.internal ? "${var.env}-iternel-alb" : "${var.env}-public-alb"
  sg_name  = var.internal ? "${var.env}-alb-iternel-sg" : "${var.env}-alb-public-sg"
}