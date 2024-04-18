# RDS Subnet Group Creation.
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.db_subnets_ids
  tags       = merge(local.tags, { Name = "${local.name_prefix}-subnet-group" })
}

# RDS Security Group Creation.
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-sg" })

  ingress {
    description = "RDS"
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

# RDS Parameter Group Creation.
resource "aws_db_parameter_group" "main" {
  name   = "${local.name_prefix}-pg"
  family = var.family
  tags   = "${local.name_prefix}-pg"
}

# RDS_Cluster Creation.
resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${local.name_prefix}-cluster"
  engine                  = var.engine
  engine_version          = var.engine_version
  db_subnet_group_name    = aws_db_subnet_group.main.subnet_ids
  database_name           = var.database_name
  master_username         = "foo"
  master_password         = "bar"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

# DocumentDB Cluster Instance Creation.

family         = "mysql5.6"
sg_port        = 3306
engine         = "aurora-mysql"
engine_version = "5.7.mysql_aurora.2.11.4"

database_name           = "mydb"

master_username         = "foo"
master_password         = "bar"
backup_retention_period = 5
preferred_backup_window = "07:00-09:00"