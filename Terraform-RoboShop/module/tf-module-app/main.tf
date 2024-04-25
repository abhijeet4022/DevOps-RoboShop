# Security Group Creation for Launch Template.
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
    description = "APP"
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

# Launch Template
resource "aws_launch_template" "main" {
  name                   = "${local.name_prefix}-launch-template"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = base64encode(templatefile("${path.module}/userdata.sh",
    {
      component = var.component
    }))

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.tags, { Name = "${local.name_prefix}-ec2" })

  }
}


# AutoScaling Group.
resource "aws_autoscaling_group" "main" {
  name                = "${local.name_prefix}-asg"
  vpc_zone_identifier = var.app_subnets_ids
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = [aws_lb_target_group.main.arn]
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = local.name_prefix
    propagate_at_launch = true
  }
}

# Route53 Record Creation.
resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.component == "frontend" ? "${var.env}" : "${var.component}-${var.env}"
  type    = "CNAME"
  ttl     = 10
  records = [var.component == "frontend" ? var.public_alb_name : var.private_alb_name]
}


# Target Group Create for Private LB.
resource "aws_lb_target_group" "main" {
  name     = local.name_prefix
  port     = var.sg_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Create Listener Rule. Redirect the traffic to specific TG as per domain.
resource "aws_lb_listener_rule" "main" {
  listener_arn = var.private_listener
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [
        var.component == "frontend" ? "${var.env}.learntechnology.cloud" : "${var.component}-${var.env}.learntechnology.cloud"
      ]
    }
  }
}

# Target Group Create for Public LB.
resource "aws_lb_target_group" "public" {
  count       = var.component == "frontend" ? 1 : 0 # This will run only for frontend component.
  name        = "${local.name_prefix}-public"
  port        = var.sg_port
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = var.default_vpc_id # This TG is part of Public LB.
}

# Attach the Private LB IP with Above TG.
resource "aws_lb_target_group_attachment" "public" {
  # This will iterate only for frontend.
  count             = var.component == "frontend" ? length(tolist(data.dns_a_record_set.private_alb.addrs)) : 0
  target_group_arn  = aws_lb_target_group.public.arn
  target_id         = element(tolist(data.dns_a_record_set.private_alb.addrs), count.index )
  port              = 80
  availability_zone = "all"
}

# Create listener rule for dev. redirect the dev.learntechnology.cloud traffic to traget gruop representing the private lb ip.
resource "aws_lb_listener_rule" "public" {
  count        = var.component == "frontend" ? 1 : 0
  listener_arn = var.public_listener
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public[0].arn
  }

  condition {
    host_header {
      values = ["${var.env}.learntechnology.cloud"]
    }
  }
}