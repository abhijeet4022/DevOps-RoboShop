# Subnet Group creation
resource "aws_docdb_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.db_subnets_ids
  tags       = merge(local.tags, { Name = "${local.name_prefix}-subnet-group" })
}

# Security Group creation
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-sg" })

  ingress {
    description = "DocumentDB"
    from_port   = "27017"
    to_port     = "27017"
    protocol    = "tcp"
    cidr_blocks = var.db_sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}