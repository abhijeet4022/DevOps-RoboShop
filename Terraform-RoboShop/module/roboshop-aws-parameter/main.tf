# Parameter Creation
resource "aws_ssm_parameter" "main" {
  for_each = var.parameters
  name     = each.key
  type     = each.value["type"]
  value    = each.value["value"]
  key_id   = "arn:aws:kms:us-east-1:767398040211:key/2e711605-a22c-4302-9087-c8ef84499250"
}

