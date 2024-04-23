locals {
  tags        = merge(var.tags, { tf-module-name = "rabbitmq" }, { env = var.env })
  name_prefix = "${var.env}-rabbitmq"
}

