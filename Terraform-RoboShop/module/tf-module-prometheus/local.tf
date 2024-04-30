locals {
  tags     = merge(var.tags, { tf-module-name = "prometheus" }, { env = var.env })
   sg_name  = "${var.env}-prometheus-sg"
}