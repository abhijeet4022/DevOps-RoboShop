# Prometheus Security Group Creation
resource "aws_security_group" "main" {
  name        = local.sg_name
  description = local.sg_name
  vpc_id      = var.default_vpc_id
  tags        = merge(local.tags, { Name = local.sg_name })
  ingress {
    description = "ALL"
    from_port   = var.all_ports
    to_port     = var.all_ports
    protocol    = "tcp"
    cidr_blocks = var.internet_ingress_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# Prometheus Instance Creation.
resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  tags                   = merge(local.tags, { Name = "Prometheus" })
}