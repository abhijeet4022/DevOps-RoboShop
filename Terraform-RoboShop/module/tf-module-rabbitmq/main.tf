# Security Group Creation for RabbitMQ.
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-sg" })

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_subnets_cidr
  }
  ingress {
    description = "RabbitMQ"
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


# RabbitMQ Message Broker Instance Creation.
resource "aws_instance" "main" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = var.db_subnets_ids[0]
  vpc_security_group_ids = [aws_security_group.main.id]
  tags                   = merge(local.tags, { Name = local.name_prefix } )
  user_data              = base64encode(templatefile("${path.module}/userdata.sh",
    {
      env = "dev"
    }))
}

# Route53 Record Creation.
resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.env}"
  type    = "A"
  ttl     = 10
  records = [aws_instance.main.private_ip]
}

