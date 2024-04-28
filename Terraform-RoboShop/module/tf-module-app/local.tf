locals {
  tags        = merge(var.tags, { tf-module-name = "app" }, { env = var.env })
  name_prefix = "${var.env}-${var.component}"
  parameters = concat(var.parameters, [var.component])
  policy_resources = [ for i in local.parameters: "arn:aws:ssm:us-east-1:767398040211:parameter/${i}.${var.env}.*" ]
}



