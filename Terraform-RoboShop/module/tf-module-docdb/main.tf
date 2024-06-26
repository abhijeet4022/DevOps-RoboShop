# DocumentDB Subnet Group Creation.
resource "aws_docdb_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.db_subnets_ids
  tags       = merge(local.tags, { Name = "${local.name_prefix}-subnet-group" })
}

# Security Group Creation.
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

# Parameter Group creation for database
resource "aws_docdb_cluster_parameter_group" "main" {
  family      = var.engine_family
  name        = "${local.name_prefix}-pg"
  description = "${local.name_prefix}-pg"
  tags        = merge(local.tags, { Name = "${local.name_prefix}-pg" })
}

# docdb_cluster creation
resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${local.name_prefix}-cluster"
  engine                          = "docdb"
  engine_version                  = var.engine_version
  master_username                 = data.aws_ssm_parameter.master_username.value
  master_password                 = data.aws_ssm_parameter.master_password.value
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = var.skip_final_snapshot
  vpc_security_group_ids          = [aws_security_group.main.id]
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  tags                            = merge(local.tags, { Name = "${local.name_prefix}-cluster" })

}

# DocumentDB Cluster Instance Creation.
resource "aws_docdb_cluster_instance" "main" {
  count              = var.instance_count
  identifier         = "${local.name_prefix}-cluster-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.instance_class
}

