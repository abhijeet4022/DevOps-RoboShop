locals {
  tags        = merge(var.tags, { tf-module-name = "app" }, { env = var.env })
  name_prefix = "${var.env}-${var.component}"
}

