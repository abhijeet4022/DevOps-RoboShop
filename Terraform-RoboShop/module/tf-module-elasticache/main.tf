# ElastiCache Subnet Group Creation.
resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.db_subnets_ids
  tags       = merge(local.tags, { Name = "${local.name_prefix}-subnet-group" })
}


# ElastiCache Security Group Creation.
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-sg" })

  ingress {
    description = "ELASTICACHE"
    from_port   = var.sg_port
    to_port     = var.sg_port
    protocol    = "tcp"
    cidr_blocks = var.app_subnets_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# ElastiCache Parameter Group Creation.
resource "aws_elasticache_parameter_group" "main" {
  name   = "${local.name_prefix}-pg"
  family = var.family
  tags   = merge(local.tags, { Name = "${local.name_prefix}-pg" })
}


#Create ElastiCache Cluster
resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${local.name_prefix}-cluster"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.engine_version
  port                 = var.sg_port
  parameter_group_name = aws_elasticache_parameter_group.main.name
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.main.id]
  tags                 = merge(local.tags, { Name = "${local.name_prefix}-cluster" })
}

