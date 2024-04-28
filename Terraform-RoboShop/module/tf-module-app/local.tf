locals {
  tags        = merge(var.tags, { tf-module-name = "app" }, { env = var.env })
  name_prefix = "${var.env}-${var.component}"
  # This will take the value docdb and component.
  parameters = concat(var.parameters, [var.component])
  # This for will take docdb and component and will give two output one for docdb and one for component so in policy two resource will be taken care.
  policy_resources = [ for i in local.parameters: "arn:aws:ssm:us-east-1:767398040211:parameter/${i}.${var.env}.*" ]
}



