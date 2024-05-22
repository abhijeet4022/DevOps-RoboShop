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
  ingress {
    description = "PROMETHEUS"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = var.monitoring_ingress_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "nginx_exporter" {
  count             = var.component == "frontend" ? 1 : 0
  type              = "ingress"
  from_port         = 9113
  to_port           = 9113
  protocol          = "tcp"
  cidr_blocks       = var.monitoring_ingress_cidr
  security_group_id = aws_security_group.main.id
  description       = "Nginx Prometheus Exporter"
}


# Launch Template
resource "aws_launch_template" "main" {
  name                   = "${local.name_prefix}-launch-template"
  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile {
    name = "${local.name_prefix}-profile"
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh",
    {
      component = var.component
      env       = var.env
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
  tag {
    key                 = "Monitor"
    value               = "yes"
    propagate_at_launch = true
  }
}


# Route53 Record Creation.
resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.component == "frontend" ? "${var.env == "prod" ? "www" : var.env}" : "${var.component}-${var.env}"
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
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 5
    path                = "/health"
    port                = var.sg_port
    timeout             = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
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
        var.component == "frontend" ? "${var.env == "prod" ? "www" : var.env}.learntechnology.cloud" : "${var.component}-${var.env}.learntechnology.cloud"
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
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 5
    path                = "/"
    port                = var.sg_port
    timeout             = 2
    unhealthy_threshold = 2
    matcher             = "400"
  }
}


# Attach the Private LB IP with Above TG.
resource "aws_lb_target_group_attachment" "public" {
  # This will iterate only for frontend.
  # this count is failing because of dependency in alb module so will approach another.
  # count             = var.component == "frontend" ? length(tolist(data.dns_a_record_set.private_alb.addrs)) : 0

  # Since we know that private ALB will give only two ip because there is only two AZ so will use that.
  #count             = var.component == "frontend" ? length(var.app_subnets_ids) : 0
  count             = var.component == "frontend" ? length(var.az) : 0
  target_group_arn  = aws_lb_target_group.public[0].arn
  target_id         = element(tolist(data.dns_a_record_set.private_alb.addrs), count.index)
  port              = 80
  availability_zone = "all"
  # depends_on        = [data.dns_a_record_set.private_alb]
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
      values = ["${var.env == "prod" ? "www" : var.env}.learntechnology.cloud"]
    }
  }
}


# IAM Policy for EC2 to fetch info from SSM
resource "aws_iam_policy" "main" {
  name        = "${local.name_prefix}-ssm-policy"
  path        = "/"
  description = "${local.name_prefix}-ssm-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource" : local.policy_resources
        # This will receive two resource to add in policy.
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "ssm:DescribeParameters",
        "Resource" : "*"
      }
    ]
  })
}


# IAM Role for EC2-SSM.
resource "aws_iam_role" "main" {
  name = "${local.name_prefix}-ssm-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.tags, { Name = "${local.name_prefix}-ssm-role" })
}


# Attach the IAM Policy with IAM Role.
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}


# Create IAM Instance Profile for IAm Role
resource "aws_iam_instance_profile" "main" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.main.name
}


